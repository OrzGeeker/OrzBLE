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
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
        if let discoveredService = services.first(where: { $0.id == service.uuid.uuidString}), let includedServices = service.includedServices {
            discoveredService.includedServices = includedServices.compactMap({ cbService in
                Service(cbService: cbService)
            })
        }
         
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let discoveredService = services.first(where: { $0.id == service.uuid.uuidString}), let characteristics = service.characteristics {
            discoveredService.characteristics = characteristics.compactMap({ cbCharacteristic in
                Characteristic(cbCharacteristic: cbCharacteristic)
            })
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}


extension Peripheral {
    
    public var name: String? {
        self.cbPeripheral.name
    }
    
    public func discoverServices(_ serviceUUIDs: [UUID]? = nil) {
        self.cbPeripheral.discoverServices(serviceUUIDs?.cbUUIDs)
    }
    
    public func discoverIncludedServices(_ includedServiceUUIDs: [UUID]? = nil, for service: Service) {
        self.cbPeripheral.discoverIncludedServices(includedServiceUUIDs?.cbUUIDs, for: service.cbService)
    }
    
    public func discoverCharacteristics(_ characteristicUUIDs:[UUID]? = nil, for service: Service) {
        self.cbPeripheral.discoverCharacteristics(characteristicUUIDs?.cbUUIDs, for: service.cbService)
    }
    
}
