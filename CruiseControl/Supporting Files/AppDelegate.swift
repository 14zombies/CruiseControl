//
//  AppDelegate.swift
//  CruiseControl
//
//  Created by Calum Crawford on 02/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var controller: CruiseController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        controller = CruiseController()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        // If user relaunches application then the preferences window should be shown as
        // Status menu icon maybe hidden.
        controller?.showPreferences()
    }

    // This is for the Menu bar "Preferences…" item, not the Status menu "Preferences…" item.
    // (Top left of screen as apposed to top right)
    // The menu bar is not usually displayed, functionality to allow dock icon is implemented,
    // but not exposed to user which will show the menu bar for this application.
    @IBAction func didHitPrefs(_ sender: Any) {
        controller?.showPreferences()
    }
}
