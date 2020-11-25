//
//  LightView.swift
//  OrzBLE
//
//  Created by wangzhizhou on 2020/11/23.
//

import SwiftUI

public struct LightView: View {
    
    var isBLEOpen = true
    
    @StateObject private var viewModel = LightViewModel()
    
    public init() {}
    
    public var body: some View {
        
        VStack {
            if(viewModel.isBLEOpen || isBLEOpen) {
                VStack {
                    ColorPicker("选择灯颜色", selection: $viewModel.color, supportsOpacity: false)
                    Slider(value: $viewModel.brightness, in: 0...100)
                }.padding()
                Spacer()
                HStack {
                    Button(action: {
                        viewModel.isLightOpen.toggle()
                    }, label: {
                        Image(viewModel.isLightOpen ? "lightOn" : "lightOff", bundle: Bundle.module)
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                    })
                    .background(viewModel.color)
                    .cornerRadius(20)
                }
                Spacer()
            } else {
                Text("设备未连接")
                    .font(.title)
                    .bold()
            }
        }
        .navigationTitle(viewModel.title)
    }
}

struct LightView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LightView()
        }
        .colorScheme(.dark)
    }
}
