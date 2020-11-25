//
//  LightViewModel.swift
//  OrzBLE
//
//  Created by joker on 2020/11/23.
//
import SwiftUI
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
    
    @Published public var color: Color = .white {
        willSet (newColor) {
            
        }
    }
    
    @Published public var brightness: Float = 0
    
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
            .subscribe { (isPowerOnEvent) in
                self.isLightOpen = isPowerOnEvent.element ?? false
                self.isBLEOpen = true
            }.disposed(by: bag)
        
        light.connectedDevice
            .observeOn(MainScheduler.instance)
            .subscribe { (deviceEvent) in
                self.title = deviceEvent.element?.name ?? ""
            }.disposed(by: bag)
        
        light.bright
            .observeOn(MainScheduler.instance)
            .subscribe { (brightEvent) in
                if let bright = brightEvent.element {
                    self.brightness = Float(bright)
                }
            }
            .disposed(by: bag)
        
        connectLight()
    }
    
    func updateListStatue() {
        model.isOpen ? light.powerOn() : light.powerOff()
    }
}


extension Color {
    static func convertFromRGBTuple(_ rgb: (UInt8, UInt8, UInt8)) -> Color {
        return Color(red: Double(rgb.0), green: Double(rgb.1), blue: Double(rgb.2))
    }
}
