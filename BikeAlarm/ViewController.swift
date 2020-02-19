//
//  ViewController.swift
//  BikeAlarm
//
//  Created by James Lemkin on 2/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var centralManager : CBCentralManager!
    let alarmCBUUID = CBUUID(string: "temp")
    
    var armed = false
    var bikeInRange = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    @IBAction func ToggleAlarm(_ sender: Any) {
        armed = !armed
        updateView()
    }
    
    @IBOutlet weak var alarmInRange: UIButton!
    @IBOutlet weak var inRangeLabel: UILabel!
    @IBOutlet weak var bikeImage: UIImageView!
    
    func updateView() {
        alarmInRange.backgroundColor = armed ? UIColor.gray : UIColor.red
        alarmInRange.setTitle(armed ? "Disarm" : "Arm", for: .normal)
        inRangeLabel.text = bikeInRange ? "Bike in Range" : "Bike not in Range"
        bikeImage.isHidden = !bikeInRange
    }
    
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        @unknown default:
            print("unknown default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
    }
    
    
}
