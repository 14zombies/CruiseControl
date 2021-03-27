//
//  PreferencesDisplaying.swift
//  Cruise Control
//
//  Created by Calum Crawford on 27/03/2021.
//  Copyright © 2021 Calum Crawford. All rights reserved.
//

import Foundation
import NotificationCenter

// Will subscribe an object to the "UserDefaults.didChangeNotification" notification and call the selected
// method when that notification is received. This should be used in an part of the application that is
// displaying user preferences to allow them to be updated when any preferences change.
// The object displaying user preferences must call the subscribe() method.


protocol PreferencesDisplaying {
    func subscribe(_ selector: Selector)
}

extension PreferencesDisplaying {
    func subscribe(_ selector: Selector) {
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: UserDefaults.didChangeNotification, object: nil)
    }
}
