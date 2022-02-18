//
//  XMCTD01YL+Defines.swift
//  OrzBLE
//
//  Created by joker on 2019/1/1.
//

import CoreBluetooth

public extension XMCTD01YL {
    enum Names: String {
        case Bedside = "XMCTD_"
    }
    
    enum Services: String, ServiceIdentifier{
        case deviceInformation = "180A"
        case mcu = "8E2F0CBD-1A66-4B53-ACE6-B494E25F87BD"
        
        public var uuid: CBUUID {
            return CBUUID(string: self.rawValue)
        }
    }
    
    enum Characteristc: String, CharacteristicIdentifier {
        
        case manufactureName = "2A29"
        case modelNumber = "2A24"
        
        case control = "AA7D3F34-2D4F-41E0-807F-52FBF8CF7443"
        case status = "8F65073D-9F57-4AAA-AFEA-397D19D5BBEB"
        
        public var uuid: CBUUID {
            return CBUUID(string: self.rawValue)
        }
        
        public var service: ServiceIdentifier {
            switch self {
            case .manufactureName: fallthrough
            case .modelNumber:
                return Services.deviceInformation
                
            case .control: fallthrough
            case .status:
                return Services.mcu
            }
        }
    }
    
    enum Commands {
        case status
        case powerOn,powerOff
        case authAccess
        case bright(UInt8)
        case color((R: UInt8,G: UInt8,B: UInt8, brightness: UInt8))
        case daylight
        case transition
        case movieNight
        case ambilight
        case disconnect
        case another
        
        var data: Data {
            
            var cmdData = Data(count:18)
            
            switch self {
            case .status:
                cmdData[0] = 0x43
                cmdData[1] = 0x44
            case .powerOn:
                cmdData[0] = 0x43
                cmdData[1] = 0x40
                cmdData[2] = 0x01
            case .powerOff:
                cmdData[0] = 0x43
                cmdData[1] = 0x40
                cmdData[2] = 0x02
            case .authAccess:
                cmdData[0] = 0x43
                cmdData[1] = 0x67
                cmdData[2] = 0x68
                cmdData[3] = 0x3E
                cmdData[4] = 0x34
                cmdData[5] = 0x08
                cmdData[6] = 0xB2
                cmdData[7] = 0xCD
            case .bright(let brightness):
                cmdData[0] = 0x43
                cmdData[1] = 0x42
                cmdData[2] = brightness
            case .color(let color):
                cmdData[0] = 0x43
                cmdData[1] = 0x41
                cmdData[2] = color.R
                cmdData[3] = color.G
                cmdData[4] = color.B
                cmdData[6] = color.brightness
            case .daylight:
                cmdData[0] = 0x43
                cmdData[1] = 0x4A
                cmdData[2] = 0x01
                cmdData[3] = 0x01
                cmdData[4] = 0x01
            case .transition:
                cmdData[0] = 0x43
                cmdData[1] = 0x7F
                cmdData[2] = 0x03
            case .another:
                cmdData[0] = 0x43
                cmdData[1] = 0x43
                cmdData[2] = 0x0C
                cmdData[3] = 0x80
                cmdData[4] = 0x50
            case .movieNight:
                cmdData[0] = 0x43
                cmdData[1] = 0x41
                cmdData[2] = 0x14
                cmdData[3] = 0x14
                cmdData[4] = 0x32
                cmdData[6] = 0x32 // >=74 白光会亮
            case .ambilight:
                cmdData[0] = 0x43
                cmdData[1] = 0x4A
                cmdData[2] = 0x02
                cmdData[3] = 0x01
                cmdData[4] = 0x01
            case .disconnect:
                cmdData[0] = 0x43
                cmdData[1] = 0x52
            }
            return cmdData
        }
    }
    enum MessageTip: String {
        case disconnected = "device disconnected!"
        case authTip = "Need auth! You should press the mode change Button of Yeelight Bedside light to allow you phone control it!"
        case authSuccess = "Auth successfully!"
        case authFailed = "Auth timeout Failed!"
        case connecting = "Connecting ..."
        case connected = "device connected!"
    }
    
    enum LightMode: UInt8, Identifiable, CaseIterable {
        case unknown = 0
        case color = 1
        case day = 2
        case ambient = 3
        
        public var id: UInt8 { self.rawValue }
    }
}
