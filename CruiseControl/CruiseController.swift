//
//  CruiseController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 11/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import UserNotifications

final class CruiseController {
    
    // CruiseController is the main coordinator for the application and allows all the components
    // to talk to each other without knowing anything about each other
    // (This comment was made by the Protocols gang)
    fileprivate var events: [EventController] = [] // Watches for the caps lock key press.
    fileprivate let notificationController: NotificationController // Request authorisation and sends notifications.
    fileprivate let preferences: Preferences // Preferences store.
    fileprivate let status: StatusMenuController // Builds and responds to Status menu interactions
    fileprivate let windowController: NSWindowController? // Manages the window, see Apple documentation for more.
    
    init() {
        let capsLockEvents = EventController(keyCode: 57, keyName: "Caps Lock")
        self.notificationController = NotificationController()
        self.preferences = Preferences()
        self.status = StatusMenuController(prefs: self.preferences)
        self.windowController = NSStoryboard.main?.instantiateController(
            withIdentifier: "CruiseControlPreferencesWindow") as? NSWindowController
        self.windowController?.contentViewController?.representedObject = preferences
        capsLockEvents.notificationDelegate = self
        self.status.preferencesDelegate = self
        self.status.aboutDelegate = self
        
        self.events.append(capsLockEvents)
        
    }

}

extension CruiseController: Notifying {

    func willNotify(keyEnabled: Bool, keyName: String) {
        // This method will drop the notification request based on user preference.
        // Event controller is intentionally ignorant and will request a notification
        // knowing nothing about user notification preference.
        
        let capsLockStateString = keyEnabled ? "On" : "Off"
        let message = "\(keyName) is \(capsLockStateString)"

        switch preferences.notificationBehaviour {
        case (.capsOn):
            if keyEnabled {
                notificationController.notify(message: message, sound: preferences.notificationSound)
            }
        case (.capsOff):
            if !keyEnabled {
                notificationController.notify(message: message, sound: preferences.notificationSound)
            }
        case (.both):
            notificationController.notify(message: message, sound: preferences.notificationSound)
        case (.disabled):
            break
        }
    }
}

extension CruiseController: PreferencesShowing {
    func showPreferences() {
        NSApp.activate(ignoringOtherApps: true)
        self.windowController?.showWindow(self)
    }
}

extension CruiseController: AboutShowing {
    func showAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
}
