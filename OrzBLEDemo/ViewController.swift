//
//  ViewController.swift
//  OrzBLEDemo
//
//  Created by joker on 2018/12/30.
//  Copyright © 2018 joker. All rights reserved.
//

import UIKit
import OrzBLE
import RxSwift

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    
    let light = XMCTD01YL.shared
    
    @IBOutlet weak var lightSwitch: UISwitch!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        sender.isOn ? light.powerOff() : light.powerOn()
        sender.isOn = !sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        light.power.subscribe(onNext: { (isPowerOn) in
            self.lightSwitch.isOn = isPowerOn
        }).disposed(by: bag)
        
        light.connect()
    }
}
