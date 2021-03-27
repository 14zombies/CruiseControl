//
//  PreferencesViewController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 02/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    // Responds to events from the Preferences window.
    
    @IBOutlet weak var launchAtLogin: NSButton!
    @IBOutlet weak var monoIcon: NSButton!
    @IBOutlet weak var notificationsBehavior: NSPopUpButton!
    @IBOutlet weak var notificationsPreferences: NSButton!
    @IBOutlet weak var notificationsSound: NSPopUpButton!
    @IBOutlet weak var showMenuBar: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribe(#selector(updateUI))
    }

    override var representedObject: Any? {didSet {
        updateUI()
    }}

    @objc func updateUI() {
        if let preferences = self.representedObject as? Preferences {
            self.launchAtLogin.state = preferences.launchAtLogin ? .on : .off
            self.monoIcon.state = preferences.isMonoIcon ? .on : .off
            self.notificationsBehavior.item(withTitle: preferences.notificationBehaviour.rawValue)?.state = .on
            self.notificationsBehavior.selectItem(withTitle: preferences.notificationBehaviour.rawValue)
            self.updateNotificationSoundPopupButton(items: preferences.notificationSounds,
                                                    selected: preferences.notificationSound)
            self.showMenuBar.state = preferences.showMenu ? .on : .off
        }
    }

    func updateNotificationSoundPopupButton(items: [String], selected: String) {
        self.notificationsSound.removeAllItems()
        self.notificationsSound.addItems(withTitles: items)
        self.notificationsSound.select(self.notificationsSound.item(withTitle: selected))
    }

    @IBAction func didChangeLaunchAtLogin(_ sender: Any) {
        if let preferences = representedObject as? Preferences {
            if launchAtLogin.state == .on {
                preferences.launchAtLogin = true
            } else {
                preferences.launchAtLogin = false
            }
        }
    }

    @IBAction func didChangeShowMenuBarIcon(_ sender: Any) {
        if let preferences = representedObject as? Preferences {
            if showMenuBar.state == .on {
                preferences.showMenu = true
            } else {
                preferences.showMenu = false
            }
        }
    }

    @IBAction func didChangeMonoIcon(_ sender: Any) {
        if let preferences = representedObject as? Preferences {
            if monoIcon.state == .on {
                preferences.isMonoIcon = true
            } else {
                preferences.isMonoIcon = false
            }
        }
    }

    @IBAction func didChangeNotificationsBehavior(_ sender: Any) {
        if let preferences = representedObject as? Preferences,
           let behaviour = NotifyBehaviour(rawValue: notificationsBehavior.selectedItem!.title) {
            preferences.notificationBehaviour = behaviour
        }
    }

    @IBAction func didChangeNotificationsSound(_ sender: Any) {
        if let preferences = representedObject as? Preferences,
           let selectedItem = notificationsSound.selectedItem?.title {
            preferences.notificationSound = selectedItem
            updateNotificationSoundPopupButton(items: preferences.notificationSounds, selected: selectedItem)
        }
    }

    @IBAction func didClickNotificationsPreferences(_ sender: Any) {
        guard let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.notifications")
        else { return }
        NSWorkspace.shared.open(prefpaneUrl)
    }

    @IBAction func didClickAttributionLink(_ sender: Any) {
        if let url = URL(string: "https://www.flaticon.com/authors/smashicons") {
            NSWorkspace.shared.open(url)
        }
    }

}

extension PreferencesViewController: PreferencesDisplaying {}
