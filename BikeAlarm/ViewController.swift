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
    //var peripheralManager : CBPeripheralManager!
    var alarmPeripheral : CBPeripheral!
    var armedCharacteristic : CBCharacteristic?
    
    let alarmCBUUID = CBUUID(string: "19b10000-e8f2-537e-4f6c-d104768a1214")
    
    var armed = false {
        didSet {
            updateView()
        }
    }
    
    var bikeInRange = false {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        updateView()
    }

    @IBAction func ToggleAlarm(_ sender: Any) {
        print("HEY")
        
        let char = armedCharacteristic!
        
        if char.properties.contains(.write) && alarmPeripheral != nil {
            armed = !armed
            
            let armingData = Data([UInt8(armed ? 1 : 0)])
            alarmPeripheral.writeValue(armingData, for: char, type: .withResponse)
            
            updateView()
        }
    }
    
    @IBOutlet weak var alarmInRange: UIButton!
    @IBOutlet weak var inRangeLabel: UILabel!
    @IBOutlet weak var bikeImage: UIImageView!
    
    func updateView() {
        alarmInRange.backgroundColor = armed ? #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        alarmInRange.setTitle(armed ? "Disarm" : "Arm", for: .normal)
        inRangeLabel.text = bikeInRange ? "Bike in Range" : "Bike not in Range"
        bikeImage.isHidden = !bikeInRange
        alarmInRange.isHidden = !bikeInRange
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
            centralManager.scanForPeripherals(withServices: [alarmCBUUID])
        @unknown default:
            print("unknown default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        alarmPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(alarmPeripheral)
        alarmPeripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        
        self.bikeInRange = true
        
        alarmPeripheral.discoverServices([alarmCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.bikeInRange = false
        
        self.alarmPeripheral = nil
    }
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == alarmCBUUID {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
                
                armedCharacteristic = characteristic
                
                print("armedChar set")
            }
        } else {
            print("No characteristics")
        }
    }
}

/*extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("peripheral state is .unknown")
        case .resetting:
            print("peripheral state is .resetting")
        case .unsupported:
            print("peripheral state is .unsupported")
        case .unauthorized:
            print("peripheral state is .unauthorized")
        case .poweredOff:
            print("peripheral state is .poweredOff")
        case .poweredOn:
            let advertisementData = "James's iphone"
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[alarmCBUUID], CBAdvertisementDataLocalNameKey: advertisementData])
            
            print("peripheral state is .poweredOn")
        @unknown default:
            print("peripheral state is @unknown default")
        }
    }
}*/
