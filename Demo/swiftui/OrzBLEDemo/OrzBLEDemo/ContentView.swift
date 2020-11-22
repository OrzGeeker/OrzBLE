//
//  ContentView.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI
import OrzBLE
import RxSwift

struct ContentView: View {
    @State var isOpen: Bool = false
    private let bag = DisposeBag()
    
    var body: some View {
        VStack {
            Toggle("打开BLE设备", isOn: $isOpen)
                .padding()
        }
        .onAppear(perform: {
            XMCTD01YL.shared.power.subscribe { (isPowerOn) in
                isOpen = isPowerOn
            }.disposed(by: bag)
            XMCTD01YL.shared.connect()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
