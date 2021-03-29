//
//  AppDelegate.swift
//  CruiseControlHelper
//
//  Created by Calum Crawford on 11/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

@NSApplicationMain
class HelperAppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isHelperRunning = runningApps.filter {
            $0.bundleIdentifier == Constants.helperBundleID
        }

        if isHelperRunning.count > 1 {
            debugPrint("\(Constants.appName) is already running. Terminating")
            NSApp.terminate(nil)
        }

        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Constants.mainBundleID
        }

        if !isRunning {
            var path = Bundle.main.bundlePath as NSString
            for _ in 1...4 {
                path = path.deletingLastPathComponent as NSString
            }
            let filePathUrl = URL(fileURLWithPath: path as String)
            
            NSWorkspace.shared.openApplication(at: filePathUrl, configuration: NSWorkspace.OpenConfiguration())
        }
    }

}
