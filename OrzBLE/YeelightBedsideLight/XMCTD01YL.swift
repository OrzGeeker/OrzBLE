//
//  XMCTD01YL.swift
//  OrzBLE
//
//  Created by joker on 2018/12/30.
//  Copyright © 2018 joker. All rights reserved.
//

import RxBluetoothKit
import RxSwift
import CoreBluetooth

final public class XMCTD01YL {
    
    public static let shared = XMCTD01YL()
    
    public let power = PublishSubject<Bool>()
    public let bright = PublishSubject<UInt8>()
    public let lightMode = PublishSubject<UInt8>()
    public let lightColor = PublishSubject<(UInt8, UInt8, UInt8)>()
    public let message = PublishSubject<XMCTD01YL.message>()
    public let connectedDevice = PublishSubject<Peripheral>()
    public let error = PublishSubject<Error>()
    

    var control: Characteristic?
    var status: Characteristic?
    
    let centralManager = CentralManager(queue: .main)
    var connectDisposable: Disposable?
    var controlDisposable: Disposable?
    var statusDisposable: Disposable?
    var characteristicDisposable: Disposable?
    
    func findCharacteristic() {
        
        guard self.centralManager.state == BluetoothState.poweredOn else {
            self.control = nil
            self.status = nil
            return
        }
        
        let connectedDevices = Observable.from(centralManager.retrieveConnectedPeripherals(withServices: [XMCTD01YL.Services.mcu.uuid]))
        
        let scannedDevices = centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            .filter{ $0.advertisementData.localName == XMCTD01YL.Names.Bedside.rawValue}
            .map{ $0.peripheral }
        
        self.characteristicDisposable = Observable.from([scannedDevices, connectedDevices])
            .merge()
            .take(1)
            .timeout(10, scheduler: MainScheduler.instance)
            .flatMap { [weak self] (peripheral) -> Observable<Peripheral> in
                self?.message.onNext(.connecting)
                return peripheral.establishConnection() }
            .flatMap { [weak self] (peripheral) -> Single<[Service]> in
                self?.message.onNext(.connected)
                self?.connectedDevice.onNext(peripheral)
                return peripheral.discoverServices([XMCTD01YL.Services.mcu.uuid]) }
            .flatMap { Observable.from($0) }
            .flatMap{ $0.discoverCharacteristics([XMCTD01YL.Characteristc.control.uuid, XMCTD01YL.Characteristc.status.uuid])}
            .flatMap { Observable.from($0) }
            .subscribe(
                onNext: { [weak self](characteristic) in
                    
                    if characteristic.uuid == XMCTD01YL.Characteristc.control.uuid {
                        self?.control = characteristic
                        self?.controlDisposable = self?.control?
                            .writeValue(XMCTD01YL.Commands.authAccess.data, type: .withResponse)
                            .flatMap { $0.writeValue(XMCTD01YL.Commands.status.data, type: .withResponse) }
                            .subscribe()
                    }
                    else if characteristic.uuid == XMCTD01YL.Characteristc.status.uuid {
                        self?.status = characteristic
                        self?.statusDisposable = self?.status?
                            .observeValueUpdateAndSetNotification()
                            .subscribe({ [weak self] (event) in
                                guard let status = event.element  else {
                                    return
                                }
                                self?.processStatusData(status.value)
                            })
                    }
            })
    }
    

    func sendCommand(_ command: XMCTD01YL.Commands) {
        if let control = self.control, control.service.peripheral.isConnected {
            _ = control.writeValue(command.data, type: .withResponse).subscribe()
        }
    }
    
    func processStatusData(_ data: Data?) {
        if let data = data {
            if data[0] == 0x43 {
                //设备状态
                if data[1] == 0x45 {
                    let isPowerOn = (data[2] == 1)
                    self.power.onNext(isPowerOn)
                    self.bright.onNext(data[8])
                    self.lightMode.onNext(data[3])
                    self.lightColor.onNext((data[4],data[5],data[6]))
                }
                    //设备断开连接
                else if data[1] == 0x53 {
                    self.message.onNext(.disconnected)
                }
                    
                    //设备访问授权
                else if data[1] == 0x63 {
                    if data[2] == 0x01 {
                        self.message.onNext(.authTip)
                    }
                        
                    else if data[2] == 0x02 {
                        self.message.onNext(.authSuccess)
                    }
                    else if data[2] == 0x05 {
                        self.message.onNext(.authFailed)
                    }
                }
            }
        }
    }
}




