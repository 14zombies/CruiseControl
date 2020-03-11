//
//  NotifyBehavior.swift
//  CruiseControl
//
//  Created by Calum Crawford on 11/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Foundation


enum NotifyBehaviour: String, RawRepresentable {
    case on = "Caps Lock On"
    case off = "Caps Lock Off"
    case both = "Both"
    case disabled = "Disabled"
}
