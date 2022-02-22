//
//  Peripheral.swift
//  
//
//  Created by wangzhizhou on 2022/2/22.
//

import Foundation
import CoreBluetooth

public final class Peripheral: NSObject, ObservableObject {
    
    let cbPeripheral: CBPeripheral
    
    public init(_ cbPeripheral: CBPeripheral) {
        self.cbPeripheral = cbPeripheral
        super.init()
        self.cbPeripheral.delegate = self
    }

    public var rssi: NSNumber?
    
    @Published
    public var state: CBPeripheralState = .disconnected
    
    @Published
    public var services = [Service]()
    
}

extension Peripheral: Identifiable {
    
    public var id: UUID {
        return self.cbPeripheral.identifier
    }
}

extension Peripheral: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("发现服务们")
        
        if let services = peripheral.services {
            self.services = services.compactMap { Service(cbService: $0) }
        }
        else {
            self.services.removeAll()
        }
        
    }
}


extension Peripheral {
    
    public var name: String? {
        self.cbPeripheral.name
    }
    
    public func discoverServices(_ serviceUUIDs: [UUID]? = nil) {
        self.cbPeripheral.discoverServices(serviceUUIDs?.cbUUIDs)
    }
}
