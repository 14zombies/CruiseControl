//
//  Preferences.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import ServiceManagement


final class Preferences{
    
    private let uDefaults = UserDefaults.standard
    
    private static let defaultPrefs: [String: Any] = [
        "launchAtLogin": false,
        "monoIcon": true,
        "notificationBehaviour": "Both",
        "notificationSound": "Default",
        "showDock": false
    ]
    
    var isMonoIcon: Bool { didSet{
        uDefaults.set(isMonoIcon, forKey: "monoIcon")
    }}
    
    var launchAtLogin: Bool { didSet{
        uDefaults.set(launchAtLogin, forKey: "launchAtLogin")
        let helperBundleName = "com.14zombies.CruiseControlHelper"
        SMLoginItemSetEnabled(helperBundleName as CFString, launchAtLogin)
    }}
    
    var notificationBehaviour: NotifyBehaviour = .disabled { didSet{
        uDefaults.set(notificationBehaviour.rawValue, forKey: "notificationBehaviour")
    }}
    
    var notificationsGranted: Bool = true { didSet{
        NotificationCenter.default.post(name: .preferencesUpdated, object: nil)
    }}
    
    var notificationSound: String { didSet{
        // Check if set sound is avalible in our list, if not then do not change it.
        if !notificationSounds.contains(notificationSound) {
            notificationSound = Preferences.defaultPrefs["notificationSound"] as! String
        } else {
            uDefaults.set(notificationSound, forKey: "notificationSound")
        }
    }}
    
    var notificationSounds: [String] { get{
        let test = Bundle.main.paths(forResourcesOfType: "aiff", inDirectory: nil)
        var names: [String] = test.compactMap({ paths in
            let nameWithExtension = paths.split(separator: "/").last.map{ String($0) }
            let name = nameWithExtension?.split(separator: ".").first.map{ String($0) }
            return name
        })
        names.sort()
        names.insert("Default", at: 0)
        names.insert("None", at: 0)
        return names
    }}
    
    var showMenu: Bool { didSet{
        uDefaults.set(showMenu, forKey: "showMenu")
    }}
    
    
    
    init(){
        Preferences.registerDefaults()
        isMonoIcon = uDefaults.bool(forKey: "monoIcon")
        launchAtLogin = uDefaults.bool(forKey: "launchAtLogin")
        if let behaviourString = uDefaults.string(forKey: "notificationBehaviour"), let notificationBehaviour = NotifyBehaviour(rawValue: behaviourString) {
            self.notificationBehaviour = notificationBehaviour
        } else {
            self.notificationBehaviour = NotifyBehaviour.both
        }
        if let notificationSound =  uDefaults.string(forKey: "notificationSound") {
            self.notificationSound = notificationSound
        } else {
            self.notificationSound = "Default"
        }
        showMenu = uDefaults.bool(forKey: "showMenu")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotificationError(_:)), name: .userNotificationError, object: nil)
    }
    
    private static func registerDefaults() {
        UserDefaults.standard.register(defaults: Preferences.defaultPrefs)
    }
    
    @objc private func didRecieveNotificationError(_ granted: Bool){
        notificationsGranted = granted
    }
}
