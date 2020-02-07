//
//  ViewController.swift
//  BikeAlarm
//
//  Created by James Lemkin on 2/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //"Icon made by mynamepong from www.flaticon.com"

    var alarm = Alarm()

    @IBOutlet weak var alarmStatusLabel: UILabel!
    @IBOutlet weak var alarmButton: UIButton!
    
    override func viewDidLoad() {
        //alarm.connected = false
        
        setAlarmText()
        updateButton()
    }
    
    func setAlarmText() {
        alarmStatusLabel.text = alarm.connected ? "Bike in Range" : "Bike not in Range"
    }
    
    func setButtonText() {
        alarmButton.setTitle(alarm.armed ? "Disarm" : "Arm", for: UIControl.State.normal)
    }
    
    func setButtonColor() {
        if alarm.armed {
            alarmButton.backgroundColor = UIColor.gray
        } else {
            alarmButton.backgroundColor = UIColor.red
        }
    }
    
    func updateButton() {
        alarmButton.isHidden = !alarm.connected
        
        setButtonColor()
        setButtonText()
    }

    @IBAction func toggleAlarm(_ sender: Any) {
        alarm.toggle()
        
        updateButton()
    }
}

