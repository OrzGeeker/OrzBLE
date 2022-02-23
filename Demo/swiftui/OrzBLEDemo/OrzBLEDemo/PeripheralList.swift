//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/2/22.
//

import SwiftUI
import OrzBLE

struct PeripheralList: View {

    @StateObject
    private var central = Central()

    @State
    private var bleStatus: String = ""

    var body: some View {
        VStack {
            List(central.discoveredPeripherals.filter({ $0.name != nil })) { peripheral in
                NavigationLink {
                    PeripheralDetail(peripheral: peripheral).environmentObject(central)
                } label: {
                    PeripheralListItem(peripheral: peripheral)
                }
            }
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
            } else {
                central.discoveredPeripherals.removeAll()
            }
        }
    }
}

struct PeripheralListItem: View {

    var peripheral: Peripheral

    var body: some View {
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
}
