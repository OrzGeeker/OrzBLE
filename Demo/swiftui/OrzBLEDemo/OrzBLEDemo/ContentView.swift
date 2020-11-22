//
//  ContentView.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI
import OrzBLE

struct ContentView: View {
    
    @StateObject var viewModel = LightViewModel()

    var body: some View {
        VStack {
            Toggle("打开BLE设备", isOn: $viewModel.isLightOpen)
                .padding()
        }
        .onAppear(perform: {
            viewModel.connectLight()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
