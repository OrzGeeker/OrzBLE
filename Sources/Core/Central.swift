//
//  Central.swift
//  
//
//  Created by wangzhizhou on 2022/2/18.
//

import Foundation
import CoreBluetooth
import Combine

public final class Central: NSObject, ObservableObject {
    
    private lazy var manager: CBCentralManager = {
        CBCentralManager(delegate: self, queue: nil, options: nil)
    }()
    
    // 存放已经发现的外设
    private var discoveredPeripheral = [CBPeripheral]()
    
    
    @Published var status: String?
    
}

public extension Central {
    
    /// 启动外设扫描
    func startScan() {
        
        guard !self.manager.isScanning else { return }
        
        self.manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    /// 停止外设扫描
    func stopScan() {
        
        guard self.manager.isScanning else { return }
        
        self.manager.stopScan()
    }
}


extension Central: CBCentralManagerDelegate {
    
    /// 监听蓝牙设备状态及可用性
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            self.status = "未知"
        case .poweredOff:
            self.status = "关闭"
        case .poweredOn:
            self.status = "打开"
        case .resetting:
            self.status = "重置中..."
        case .unauthorized:
            self.status = "未授权"
        case .unsupported:
            self.status = "设备不支持"
        @unknown default:
            self.status = "不合法状态"
        }
    }
    
    /// 发现外设回调
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.discoveredPeripheral.append(peripheral)
    }
    
    /// 外设连接成功回调
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
}
