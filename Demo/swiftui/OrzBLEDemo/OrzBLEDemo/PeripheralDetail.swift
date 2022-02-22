//
//  PeripheralDetail.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2022/2/22.
//

import SwiftUI
import OrzBLE

struct PeripheralDetail: View {
    
    @EnvironmentObject
    var central: Central
    
    @StateObject
    var peripheral: Peripheral
    
    @State
    var isConnected = false
    
    var body: some View {
        VStack {
            List(peripheral.services) { service in
                Text(service.id)
                    .font(.system(size: 10))
            }
        }
        .onAppear(perform: {
            central.connectPeripheral(peripheral)
        })
        .onDisappear(perform: {
            central.cancelConnectPeripheral(peripheral)
        })
        .navigationTitle(peripheral.name ?? "")
        .toolbar {
            Toggle(isOn: $isConnected) {
                Text(isConnected ? "connected" : "disconnected").font(.system(size: 8))
            }
            .onReceive(peripheral.$state) { state in
                isConnected = state == .connected
                
                if isConnected {
                    peripheral.discoverServices()
                }
            }
            .disabled(false)
        }
    }
}
