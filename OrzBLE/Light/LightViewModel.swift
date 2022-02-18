//
//  LightViewModel.swift
//  OrzBLE
//
//  Created by joker on 2020/11/23.
//
import SwiftUI
import Combine

final class LightViewModel: ObservableObject {
    
    @Published public var isLightOpen: Bool = false
    
    @Published public var isBLEOpen = false
    
    @Published public var isConnected = false
    
    @Published public var title: String = "床头灯"
    
    @Published public var color: Color = .white {
        willSet(newValue) {
            if newValue != color {
                changeColor(newValue)
            }
        }
    }
    
    @Published public var brightness: Float = 0 {
        willSet(newValue) {
            if newValue != brightness {
                lightBright(UInt8(newValue))
            }
        }
    }

    @Published public var messageContent: String = ""
    
    @Published public var lightMode: XMCTD01YL.LightMode  = XMCTD01YL.LightMode.day {
         willSet(newValue) {
            if newValue != lightMode {
                changeLightMode(newValue)
            }
        }
    }
    
    init() {
        configLight()
    }
    
    func toggleLight() {
        self.isLightOpen ? light.powerOff() : light.powerOn()
    }
    
    func lightBright(_ brightness: UInt8) {
        light.brightLight(brightness)
    }
    
    func changeColor(_ color: Color) {
        if self.lightMode == .color,
           let rgbTupler = self.color.convertToRGBTuple() {
            let arg = (R: rgbTupler.0, G: rgbTupler.1, B: rgbTupler.2, brightness: UInt8(self.brightness))
            light.sendCommand(.color(arg))
        }
    }
    
    func changeLightMode(_ mode: XMCTD01YL.LightMode) {
        switch mode {
        case .day:
            light.sendCommand(.daylight)
        case .ambient:
            light.sendCommand(.ambilight)
        case .color:
            changeColor(self.color)
        default:
            break
        }
    }
    
    func toggleConnect() {
        if(self.isConnected) {
            disconnectLight()
        } else {
            connectLight()
        }
    }
    
    // MARK: 私有成员和函数
    
    private let bag = DisposeBag()
    
    private let light = XMCTD01YL.shared
    
    private func configLight() {
        
        light.power
            .observeOn(MainScheduler.instance)
            .subscribe { (isPowerOnEvent) in
                self.isLightOpen = isPowerOnEvent.element ?? false
            }.disposed(by: bag)
        
        light.connectedDevice
            .observeOn(MainScheduler.instance)
            .subscribe { (deviceEvent) in
                self.title = deviceEvent.element?.name ?? ""
            }.disposed(by: bag)
        
        light.bright
            .observeOn(MainScheduler.instance)
            .subscribe { (brightEvent) in
                if let bright = brightEvent.element {
                    self.brightness = Float(bright)
                }
            }
            .disposed(by: bag)
        
        light.lightMode
            .observeOn(MainScheduler.instance)
            .subscribe { (modeEvent) in
                if let mode = modeEvent.element {
                    self.lightMode = mode
                }
            }.disposed(by: bag)
        
        light.message
            .observeOn(MainScheduler.instance)
            .subscribe { (messageEvent) in
                if let message = messageEvent.element {
                    switch message {
                    case .authTip:
                        self.messageContent = "正在授权，你需要按一下床头灯上的小按钮授权App连接设备"
                    case .authFailed:
                        self.messageContent = "授权失败"
                    case .connecting:
                        self.messageContent = "正在连接设备..."
                    case .disconnected:
                        self.isConnected = false
                        self.messageContent = "设备连接断开了"
                    case .authSuccess:
                        self.messageContent = "授权成功"
                    case .connected:
                        self.isConnected = true
                        self.messageContent = "连接成功"
                        break
                    }
                }
            }.disposed(by: bag)
        
        light.bleStatus
            .observeOn(MainScheduler.instance)
            .subscribe { (bleStatusEvent) in
                if let bleStatus = bleStatusEvent.element {
                    switch bleStatus {
                    case .poweredOn:
                        self.isBLEOpen = true
                    default:
                        self.isBLEOpen = false
                    }
                }
            }.disposed(by: bag)
        
        connectLight()
    }
    
    private func connectLight() {
        light.connect()
    }
    
    private func disconnectLight() {
        light.sendCommand(.disconnect)
    }
}

typealias RGBTuple = (UInt8, UInt8, UInt8)
extension Color {
    static func convertFromRGBTuple(_ rgb: RGBTuple) -> Color {
        return Color(red: Double(rgb.0), green: Double(rgb.1), blue: Double(rgb.2))
    }
    
    func convertToRGBTuple() -> RGBTuple? {
        guard let cgColor = self.cgColor,
              let r = cgColor.components?[0],
              let g = cgColor.components?[1],
              let b = cgColor.components?[2] else {
            return nil
        }
        
        let R: UInt8 = UInt8(r * 255);
        let G: UInt8 = UInt8(g * 255);
        let B: UInt8 = UInt8(b * 255);
        return (R, G, B);
    }
}
