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

    @Published
    public var rssi: NSNumber?
}

extension Peripheral: Identifiable {
    
    public var id: UUID {
        return self.cbPeripheral.identifier
    }
}

extension Peripheral: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        self.rssi = error == nil ? nil : RSSI
    }
}


extension Peripheral {
    public var name: String? {
        return cbPeripheral.name
    }
    
    public func readRssi() {
        self.cbPeripheral.readRSSI()
    }
}
