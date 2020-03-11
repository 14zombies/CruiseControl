//
//  PreferencesViewController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 02/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var colorIcon: NSButton!
    @IBOutlet weak var launchAtLogin: NSButton!
    @IBOutlet weak var notifyBehavior: NSPopUpButton!
    @IBOutlet weak var notificationSound: NSPopUpButton!
    @IBOutlet weak var notificationsDisabled: NSTextField!
    @IBOutlet weak var showMenuBar: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .preferencesUpdated, object: nil)
    }
    
    override var representedObject: Any? {didSet {
        updateUI()
    }}
    
    @objc func updateUI(){
        if let preferences = self.representedObject as? Preferences {
            self.colorIcon.state = preferences.isMenuIconMono ? .on : .off
            self.launchAtLogin.state = preferences.launchAtLogin ? .on : .off
            self.notifyBehavior.item(withTitle: preferences.notificationBehaviour.rawValue)?.state = .on
            self.notifyBehavior.selectItem(withTitle: preferences.notificationBehaviour.rawValue)
            self.updateNotificationSoundPopupButton(items: preferences.notificationSounds, selected: preferences.notificationSound)
            self.notificationsDisabled.isHidden = preferences.notificationsGranted
            self.showMenuBar.state = preferences.showMenu ? .on : .off
        }
    }
    
    func updateNotificationSoundPopupButton(items: [String], selected: String){
        self.notificationSound.removeAllItems()
        self.notificationSound.addItems(withTitles: items)
        self.notificationSound.select(self.notificationSound.item(withTitle: selected))
    }
    
    @IBAction func didChangeColorIcon(_ sender: Any) {
        if let preferences = representedObject as? Preferences{
            if colorIcon.state == .on {
                preferences.isMenuIconMono = true
            } else {
                preferences.isMenuIconMono = false
            }
            didChangePreference()
        }
    }
    
    @IBAction func didChangeMenuBarIcon(_ sender: Any) {
        if let prefereneces = representedObject as? Preferences{
            if showMenuBar.state == .on {
                prefereneces.showMenu = true
            } else {
                prefereneces.showMenu = false
            }
            didChangePreference()
        }
    }
    
    @IBAction func didChangeLaunchAtLogin(_ sender: Any) {
        if let preferences = representedObject as? Preferences {
            if launchAtLogin.state == .on {
                preferences.launchAtLogin = true
            } else {
                preferences.launchAtLogin = false
            }
            didChangePreference()
        }
    }
    
    @IBAction func didChangeNotifyBehavior(_ sender: Any) {
        if let preferences = representedObject as? Preferences, let behaviour = NotifyBehaviour(rawValue: notifyBehavior.selectedItem!.title){
            preferences.notificationBehaviour = behaviour
            didChangePreference()
        }
    }
    
    @IBAction func didChangeNotificationSound(_ sender: Any) {
        if let preferences = representedObject as? Preferences, let selectedItem = notificationSound.selectedItem?.title{
            preferences.notificationSound = selectedItem
            updateNotificationSoundPopupButton(items: preferences.notificationSounds, selected: selectedItem)
            didChangePreference()
        }
        
    }
    
    @IBAction func didClickAttributionLink(_ sender: Any) {
        if let url = URL(string: "https://www.flaticon.com/authors/smashicons"){
            NSWorkspace.shared.open(url)
        }
    }
    
    private func didChangePreference(){
        NotificationCenter.default.post(name: .preferencesUpdated, object: nil)
    }
}

