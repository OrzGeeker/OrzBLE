//
//  LightViewModel.swift
//  OrzBLEDemo
//
//  Created by joker on 2020/11/23.
//
import Combine
import RxSwift

final class LightViewModel: ObservableObject {
    
    @Published var isLightOpen: Bool = false {
        willSet(newValue) {
            model.isOpen = newValue
            updateListStatue()
        }
    }
    
    func configLight() {
        light.power.subscribe { (isPowerOn) in
            self.isLightOpen = isPowerOn
        }.disposed(by: bag)
    }

    func connectLight() {
        light.connect()
    }
    
    func updateListStatue() {
        model.isOpen ? light.powerOn() : light.powerOff()
    }
    
    @Published private var model = LightModel()
    
    private let bag = DisposeBag()
    private let light = XMCTD01YL.shared
    
    init() {
        configLight()
    }
}
