//
//  Service.swift
//  
//
//  Created by wangzhizhou on 2022/2/22.
//

import CoreBluetooth
import SwiftUI

public final class Service: ObservableObject {
    let cbService: CBService
    
    init(cbService: CBService) {
        self.cbService = cbService
    }
    
    public var isPrimary: Bool {
        cbService.isPrimary
    }
    
    @Published
    public var includedServices = [Service]()
    
    @Published
    public var characteristics = [Characteristic]()
    
}

extension Service: Identifiable {
    public var id: String {
        cbService.uuid.uuidString
    }
}


public struct Characteristic {
    let cbCharacteristic: CBCharacteristic
}

extension Characteristic: Identifiable {
    public var id: String {
        cbCharacteristic.uuid.uuidString
    }
}
