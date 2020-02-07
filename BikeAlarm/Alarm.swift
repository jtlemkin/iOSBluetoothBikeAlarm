//
//  Alarm.swift
//  BikeAlarm
//
//  Created by James Lemkin on 2/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation

struct Alarm {
    var armed = true
    var connected = true
    
    mutating func toggle() {
        armed = !armed
    }
}
