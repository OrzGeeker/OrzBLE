//
//  LightView.swift
//  OrzBLE
//
//  Created by wangzhizhou on 2020/11/23.
//

import SwiftUI

public struct LightView: View {
    
    @StateObject private var viewModel = LightViewModel()
    
    public init() {
    }
    
    public var body: some View {
        VStack {
            Toggle("打开BLE设备", isOn: $viewModel.isLightOpen)
                .padding()
        }
        .onAppear(perform: {
            viewModel.connectLight()
        })
    }
}

struct LightView_Previews: PreviewProvider {
    static var previews: some View {
        LightView()
    }
}
