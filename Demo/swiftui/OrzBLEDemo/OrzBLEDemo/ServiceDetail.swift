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

    @StateObject
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
        }.font(.system(size: 12))
        .onAppear {
            peripheral.discoverIncludedServices(for: service)
            peripheral.discoverCharacteristics(for: service)
        }
    }
}
