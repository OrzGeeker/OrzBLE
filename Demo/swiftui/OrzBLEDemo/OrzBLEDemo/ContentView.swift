//
//  ContentView.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI

struct ContentView: View {
    @State var isOpen: Bool = false
    var body: some View {
        Toggle("打开BLE设备", isOn: $isOpen)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
