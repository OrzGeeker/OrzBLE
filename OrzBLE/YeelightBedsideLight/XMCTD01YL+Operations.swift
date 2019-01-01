//
//  XMCTD01YL+Operations.swift
//  OrzBLE
//
//  Created by joker on 2019/1/1.
//

import CoreBluetooth
import RxBluetoothKit
import RxSwift

public extension XMCTD01YL {
    
    public func connect() {
        
        self.disconnect()
        
        self.connectDisposable = centralManager
            .observeState()
            .startWith(self.centralManager.state)
            .subscribe { [weak self] (event) in
                self?.findCharacteristic()
        }
    }
    
    public func disconnect() {
        
        if let peripheral = self.control?.service.peripheral.peripheral {
            self.centralManager.manager.cancelPeripheralConnection(peripheral);
        }
        
        self.connectDisposable?.dispose()
        self.characteristicDisposable?.dispose()
        self.controlDisposable?.dispose()
        self.statusDisposable?.dispose()
    }
    
    public func powerOn() {
        self.sendCommand(.powerOn)
    }
    
    public func powerOff() {
        self.sendCommand(.powerOff)
    }
    
    public func dayLight() {
        self.sendCommand(.daylight)
    }
    
    public func ambiLight() {
        self.sendCommand(.ambilight)
    }
    
    public func colorLight(_ RGB: (R: UInt8, G: UInt8, B: UInt8, brightness: UInt8)) {
        self.sendCommand(.color(RGB))
    }
    
    public func brightLight(_ bright: UInt8) {
        self.sendCommand(.bright(bright))
    }
    
    
}
