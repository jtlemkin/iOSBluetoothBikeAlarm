//
//  ViewController.swift
//  BikeAlarm
//
//  Created by James Lemkin on 2/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var armed = false
    var bikeInRange = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

