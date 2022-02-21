//
//  ContentView.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI
import OrzBLE

struct ContentView: View {
    
    @ObservedObject
    private var central = Central()
    
    @State
    private var bleStatus: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(central.discoveredPeripherals.filter({ $0.name != nil })) { peripheral in
                    VStack(alignment: .leading) {
                        HStack {
                            if let name = peripheral.name {
                                Text(name)
                            }
                            Spacer()
                            if let rssi = peripheral.rssi {
                                Text("\(rssi) dB")
                            }
                        }
                        Text(peripheral.id.uuidString)
                    }
                    .font(.system(size: 12))
                }
                Spacer()
            }
            .navigationTitle(Text(bleStatus))
            .onAppear {
                central.turnOn()
                central.scan()
            }
            .onDisappear {
                central.stopScan()
            }
            .onReceive(central.$state) { state in
                bleStatus = Central.stateDesc(state)
                if state == .poweredOn {
                    central.scan()
                }
            }
        }
    }
}
