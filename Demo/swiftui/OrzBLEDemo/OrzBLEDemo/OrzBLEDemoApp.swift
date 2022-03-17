//
//  OrzBLEDemoApp.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI
import OrzBLE

@main
struct OrzBLEDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PeripheralList()
                    .environmentObject(Central())
            }
        }
    }
}
