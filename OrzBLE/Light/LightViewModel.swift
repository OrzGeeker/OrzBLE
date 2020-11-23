//
//  LightViewModel.swift
//  OrzBLEDemo
//
//  Created by joker on 2020/11/23.
//
import Combine
import RxSwift

public final class LightViewModel: ObservableObject {
    
    @Published public var isLightOpen: Bool = false {
        willSet(newValue) {
            model.isOpen = newValue
            updateListStatue()
        }
    }
    
    public init() {
        configLight()
    }
    
    public func connectLight() {
        light.connect()
    }
    

    // MARK: 私有方法
    @Published private var model = LightModel()
    
    private let bag = DisposeBag()
    private let light = XMCTD01YL.shared
    

    func configLight() {
        light.power.subscribe { (isPowerOn) in
            self.isLightOpen = isPowerOn
        }.disposed(by: bag)
    }

    func updateListStatue() {
        model.isOpen ? light.powerOn() : light.powerOff()
    }
}
