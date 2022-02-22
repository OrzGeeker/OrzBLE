//
//  Service.swift
//  
//
//  Created by wangzhizhou on 2022/2/22.
//

import CoreBluetooth

public struct Service {
    let cbService: CBService
    
    public var isPrimary: Bool {
        cbService.isPrimary
    }
    
}

extension Service: Identifiable {
    public var id: String {
        cbService.uuid.uuidString
    }
}
