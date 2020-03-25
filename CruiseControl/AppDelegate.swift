//
//  AppDelegate.swift
//  CruiseControl
//
//  Created by Calum Crawford on 02/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var controller: CruiseController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.filter {
            $0.bundleIdentifier == Constants.bundleID
        }
        if isRunning.count > 1 {
            print("Cruise Control is already running. Terminating")
            NSApp.terminate(nil)
        } else {
            controller = CruiseController()
        }
    }
    
    @IBAction func didHitPrefs(_ sender: Any) {
        controller?.showPreferences()
    }
}
