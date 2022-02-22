//
//  File.swift
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
    }

    public var rssi: NSNumber?
    
    @Published
    public var state: CBPeripheralState = .disconnected
    
}

extension Peripheral: Identifiable {
    
    public var id: UUID {
        return self.cbPeripheral.identifier
    }
}

extension Peripheral: CBPeripheralDelegate {
    

}


extension Peripheral {
    
    public var name: String? {
        self.cbPeripheral.name
    }
    
    public func discoverServices(_ serviceUUIDs: [UUID]? = nil) {
        self.cbPeripheral.discoverServices(serviceUUIDs?.cbUUIDs)
    }
}
