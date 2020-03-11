//
//  CruiseController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 11/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

class CruiseController {
            
    fileprivate let events: Events
    fileprivate let notify: Notifications
    fileprivate let preferences: Preferences
    fileprivate let preferencesVC: PreferencesViewController
    fileprivate let status: Status
    fileprivate let windowController: NSWindowController?
    
    init(){
        self.events = Events()
        self.notify = Notifications()  
        self.preferences = Preferences()
        self.status = Status(prefs: self.preferences)
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = storyboard.instantiateController(withIdentifier: "CruiseControlPreferencesWindow") as? NSWindowController
        if let preferencesVC = (windowController?.contentViewController as? PreferencesViewController){
            self.preferencesVC = preferencesVC
        } else {
            fatalError()
        }

        self.events.notificationDelegate = self
        self.status.preferencesDelegate = self
        self.status.aboutDelegate = self
        self.preferencesVC.representedObject = preferences
        
        if self.preferences.showMenu == false {
            NSApp.setActivationPolicy(.accessory)
            self.showPreferences()
        }
        
    }


}

extension CruiseController: Notifying{
    
    func willNotify(capsLockEnabled: Bool) {
        let capsLockStateString = capsLockEnabled ? "On" : "Off"
        let message = "Caps Lock is \(capsLockStateString)"
        
        switch preferences.notificationBehaviour{
        case (.on):
            if capsLockEnabled{
                notify.notify(message: message, sound: preferences.notificationSound)
            }
        case (.off):
            if !capsLockEnabled{
                notify.notify(message: message, sound: preferences.notificationSound)
            }
        case (.both):
            notify.notify(message: message, sound: preferences.notificationSound)
        case (.disabled):
            break
        }
    }
}

extension CruiseController: PreferencesDisplaying{
    func showPreferences() {
        NSApp.activate(ignoringOtherApps: true)
        self.windowController?.showWindow(self)
    }
}

extension CruiseController: AboutDisplaying{
    func showAbout() {
        NSApp.activate(ignoringOtherApps: false)
        NSApp.orderFrontStandardAboutPanel(self)
    }
}

