//
//  Central.swift
//  
//
//  Created by wangzhizhou on 2022/2/18.
//

import CoreBluetooth

public final class Central: NSObject, ObservableObject {
    
    lazy var manager: CBCentralManager = {
        CBCentralManager(delegate: self, queue: nil)
    }()
 
    @Published
    public var state: CBManagerState = .unknown
    
    @Published
    public var discoveredPeripherals = [Peripheral]()
}

extension Central: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.state = central.state
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let discoveredPeripheral = Peripheral(peripheral)
        discoveredPeripheral.rssi = RSSI
        
        if let index = discoveredPeripherals.firstIndex(where: { $0.id == peripheral.identifier}) {
            discoveredPeripherals[index] = discoveredPeripheral
        }
        else {
            discoveredPeripherals.append(discoveredPeripheral)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
         print("connect success")
        
        updateDiscoveredPeripheral(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connect fail")
        
        updateDiscoveredPeripheral(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnect")
        
        updateDiscoveredPeripheral(peripheral)
    }
    
    // MARK: Helper
    
    private func updateDiscoveredPeripheral(_ cbPeripheral: CBPeripheral) {
        if let discoveredPeripheral = discoveredPeripherals.first(where: {
            $0.id == cbPeripheral.identifier
        }) {
            discoveredPeripheral.state = cbPeripheral.state
        }
    }
}

extension Central {
        
    static public func stateDesc(_ state: CBManagerState) -> String {
        switch state {
        case .unknown:
            return "未知"
        case .poweredOff:
            return "关闭"
        case .poweredOn:
            return "打开"
        case .unsupported:
            return "不支持"
        case .unauthorized:
            return "未授权"
        default:
            return "异常"
        }
    }
    
    public func turnOn() {
        _ = self.manager
    }
    
    public func scan(_ services: [UUID]? = nil, options: [String:Any]? = nil) {
        
        guard self.manager.state == .poweredOn else {
            return
        }
    
        self.manager.scanForPeripherals(withServices: services?.cbUUIDs, options: options)
    }
    
    public func stopScan() {
        
        guard self.manager.state == .poweredOn else {
            return
        }
        
        self.manager.stopScan()
    }
    
    public func connectPeripheral(_ peripheral: Peripheral, options: [String: Any]? = nil) {
        self.manager.connect(peripheral.cbPeripheral, options: options)
    }
    
    public func cancelConnectPeripheral(_ peripheral: Peripheral) {
        self.manager.cancelPeripheralConnection(peripheral.cbPeripheral)
    }
}


extension Array where Element == UUID {
    var cbUUIDs: [CBUUID] { self.map { CBUUID(nsuuid: $0) } }
}
