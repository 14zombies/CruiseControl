//
//  Preferences.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import ServiceManagement

final class Preferences {
    // Handles saving and retrieving of all preferences as well as 
    
    private let uDefaults = UserDefaults.standard
    
    // The following preferences are available:
    //      "isMonoIcon"          – Sets the status menu icon to Black & White if true.
    //      "launchAtLogin"       - Will enable the helper application to launch this app at login.
    //                              See: https://developer.apple.com/documentation/servicemanagement/1501557-smloginitemsetenabled
    //      "notificationBehavior" – Sets the type of notification the user would like,
    //                              see Types/NotifyBehaviour.swift for more info.
    //      "notificationSound"    – Sound to be played when notification is shown.
    //      "showMenu"            - If set will show the status menu icon.
    
    public var isMonoIcon: Bool { didSet {
        uDefaults.set(isMonoIcon, forKey: Keys.monoIcon)
    }}

    public var launchAtLogin: Bool { didSet {
        uDefaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
        let helperBundleName = Constants.helperBundleID as CFString
        SMLoginItemSetEnabled(helperBundleName, launchAtLogin)
    }}

    public var notificationBehaviour: NotifyBehaviour = .disabled { didSet {
        uDefaults.set(notificationBehaviour.rawValue, forKey: Keys.notificationBehaviour)
    }}

    public var notificationSound: String { didSet {
        // Check if set sound is available in our list, if not then do not change it.
        if notificationSounds.contains(notificationSound) {
            uDefaults.set(notificationSound, forKey: Keys.notificationSound)
        } else {
            notificationSound = Preferences.defaultNotificationSound
        }
    }}

    public var showMenu: Bool { didSet {
        uDefaults.set(showMenu, forKey: Keys.showMenu)
    }}
    
    public var notificationSounds: [String] = {
        // Allows custom sounds to be bundled with the application.
        // Sounds must be in "aiff" format and placed in the Resources/Sounds folder,
        // In the Target -> Build Phase tab add the sound file to "Copy Bundle Resources"
        let test = Bundle.main.paths(forResourcesOfType: "aiff", inDirectory: nil)
        var names: [String] = test.compactMap({ paths in
            let nameWithExtension = paths.split(separator: "/").last.map { String($0) }
            let name = nameWithExtension?.split(separator: ".").first.map { String($0) }
            return name
        })
        names.sort()
        names.insert(contentsOf: Preferences.systemSounds, at: 0)
        return names
    }()
    
    init() {
        Preferences.registerDefaults()

        isMonoIcon = uDefaults.bool(forKey: Keys.monoIcon)
        launchAtLogin = uDefaults.bool(forKey: Keys.launchAtLogin)

        if let behaviourString = uDefaults.string(forKey: Keys.notificationBehaviour),
           let notificationBehaviour = NotifyBehaviour(rawValue: behaviourString) {
            self.notificationBehaviour = notificationBehaviour
        } else {
            self.notificationBehaviour = NotifyBehaviour.both
        }

        if let notificationSound =  uDefaults.string(forKey: Keys.notificationSound) {
            self.notificationSound = notificationSound
        } else {
            self.notificationSound = Preferences.defaultNotificationSound
        }
        showMenu = uDefaults.bool(forKey: Keys.showMenu)
    }
}

extension Preferences {
    fileprivate static func registerDefaults() {
        UserDefaults.standard.register(defaults: Preferences.defaultPrefs)
    }

    fileprivate enum Keys {
        static let launchAtLogin = "launchAtLogin"
        static let monoIcon = "monoIcon"
        static let notificationBehaviour = "notificationBehaviour"
        static let notificationSound = "notificationSound"
        static let showDock = "showDock"
        static let showMenu = "showMenu"
    }

    fileprivate static let defaultPrefs: [String: Any] = [
        Keys.launchAtLogin: false,
        Keys.monoIcon: true,
        Keys.notificationBehaviour: "Both",
        Keys.notificationSound: Preferences.defaultNotificationSound,
        Keys.showDock: false,
        Keys.showMenu: true
    ]

    fileprivate static let defaultNotificationSound = "Default"
    
    fileprivate static let systemSounds = [
        "None",
        "Default",
        "Basso",
        "Blow",
        "Bottle",
        "Frog",
        "Funk",
        "Glass",
        "Hero",
        "Morse",
        "Ping",
        "Pop",
        "Purr",
        "Sosumi",
        "Submarine",
        "Tink"
        
    ]
}
