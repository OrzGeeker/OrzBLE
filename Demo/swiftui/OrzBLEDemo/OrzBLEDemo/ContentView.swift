//
//  ContentView.swift
//  OrzBLEDemo
//
//  Created by wangzhizhou on 2020/11/16.
//

import SwiftUI
import OrzBLE

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            LightView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
