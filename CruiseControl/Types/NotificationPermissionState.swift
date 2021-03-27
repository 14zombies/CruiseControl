//
//  NotificationPermissionState.swift
//  Cruise Control
//
//  Created by Calum Crawford on 27/03/2021.
//  Copyright © 2021 Calum Crawford. All rights reserved.
//

import Foundation

enum NotificationPermissionState {
    case notYetRequested
    case notAvailable
    case available

    func isEnabled() -> Bool {
        switch self {
        case .available:
            return true
        case .notYetRequested, .notAvailable:
            return false
        }
    }
}
