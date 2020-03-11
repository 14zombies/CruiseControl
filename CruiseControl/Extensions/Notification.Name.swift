//
//  Notification.Name.swift
//  Cruise Control
//
//  Created by Calum Crawford on 23/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let userNotificationError = Notification.Name(rawValue: "UserNotificationError")
    static let preferencesUpdated = Notification.Name(rawValue: "PreferencesUpdated")
}
