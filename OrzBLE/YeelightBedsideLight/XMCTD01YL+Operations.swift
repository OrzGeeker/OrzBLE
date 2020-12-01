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
    
    func connect() {
        
        self.disconnect()
        
        self.connectDisposable = centralManager
            .observeState()
            .startWith(self.centralManager.state)
            .distinctUntilChanged()
            .subscribe { [weak self] (event) in
                if let status = event.element {
                    if(status == .poweredOn) {
                        self?.findCharacteristic()
                    }
                    self?.bleStatus.onNext(status)
                }
                
            }
    }
    
    func disconnect() {
        
        if let peripheral = self.control?.service.peripheral.peripheral {
            self.centralManager.manager.cancelPeripheralConnection(peripheral);
        }
        
        self.connectDisposable?.dispose()
        self.characteristicDisposable?.dispose()
        self.controlDisposable?.dispose()
        self.statusDisposable?.dispose()
    }
    
    func powerOn() {
        self.sendCommand(.powerOn)
    }
    
    func powerOff() {
        self.sendCommand(.powerOff)
    }
    
    func dayLight() {
        self.sendCommand(.daylight)
    }
    
    func ambiLight() {
        self.sendCommand(.ambilight)
    }
    
    func colorLight(_ RGB: (R: UInt8, G: UInt8, B: UInt8, brightness: UInt8)) {
        self.sendCommand(.color(RGB))
    }
    
    func brightLight(_ bright: UInt8) {
        self.sendCommand(.bright(bright))
    }
    
    
}
