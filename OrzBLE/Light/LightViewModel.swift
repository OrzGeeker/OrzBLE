//
//  LightViewModel.swift
//  OrzBLE
//
//  Created by joker on 2020/11/23.
//
import Combine
import RxSwift

final class LightViewModel: ObservableObject {
    
    @Published public var isLightOpen: Bool = false {
        willSet(newValue) {
            model.isOpen = newValue
            updateListStatue()
        }
    }
    
    @Published public var isBLEOpen = false
    
    @Published public var title: String = "床头灯"
    
    init() {
        configLight()
    }
    
    func connectLight() {
        light.connect()
    }
    

    // MARK: 私有方法
    @Published private var model = LightModel()
    
    private let bag = DisposeBag()
    private let light = XMCTD01YL.shared
    

    func configLight() {
        
        light.power
            .observeOn(MainScheduler.instance)
            .subscribe { (isPowerOn) in
            self.isLightOpen = isPowerOn.element ?? false
            self.isBLEOpen = true
        }.disposed(by: bag)
        
        light.connectedDevice
            .observeOn(MainScheduler.instance)
            .subscribe { (device) in
            self.title = device.element?.name ?? ""
        }.disposed(by: bag)

        
        connectLight()
    }

    func updateListStatue() {
        model.isOpen ? light.powerOn() : light.powerOff()
    }
}
