//
//  ServiceDetail.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2022/2/22.
//

import SwiftUI
import OrzBLE

struct ServiceDetail: View {

    @EnvironmentObject
    var peripheral: Peripheral

    @ObservedObject
    var service: Service

    var body: some View {
        VStack(alignment: .leading) {
            if service.includedServices.count > 0 {
                Text("Included Services").padding()
                List(service.includedServices) { includedService in
                    Text(includedService.id)
                }
            }
            if service.characteristics.count > 0 {
                Text("Characteristics").padding()
                List(service.characteristics) { characteristic in
                    Text(characteristic.id)
                }
            }
            if service.includedServices.count == 0, service.characteristics.count == 0 {
                Text("无子服务或特性")
            }
        }.font(.system(size: 12))
        .onAppear {
            peripheral.discoverIncludedServices(for: service)
            peripheral.discoverCharacteristics(for: service)
        }
    }
}
