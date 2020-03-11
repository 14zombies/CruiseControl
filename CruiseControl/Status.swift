//
//  Status.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import UserNotifications

final class Status {

    weak var preferencesDelegate: PreferencesDisplaying?
    weak var aboutDelegate: AboutDisplaying?
    
    private var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var preferences: Preferences
    
    init(prefs: Preferences){
        self.preferences = prefs
        menuSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarMenuUpdate), name: .preferencesUpdated, object: nil)
    }
    
    fileprivate func menuSetup(){
        statusBarItem.menu = NSMenu(title: "\(Constants.appName) Status Bar Menu")
        statusBarItem.menu?.items = menuItemsSetup()
        statusBarMenuUpdate()
    }
    
    fileprivate func menuItemsSetup() -> [NSMenuItem]{
        var menuItems = [NSMenuItem]()

        let notificationItem = NSMenuItem(title: "Notification: \(preferences.notificationBehaviour)", action: nil, keyEquivalent: "")
        notificationItem.tag = 0
        menuItems.append(notificationItem)
        menuItems.append(.separator())
        menuItems.append(NSMenuItem(title: "Launch At Login", action: #selector(setLaunchAtLogin), keyEquivalent: ""))
        menuItems.append(NSMenuItem(title: "Preferences…", action: #selector(showPerferences), keyEquivalent: ","))
        menuItems.append(.separator())
        menuItems.append(NSMenuItem(title: "About \(Constants.appName)", action: #selector(showAbout), keyEquivalent: ""))
        menuItems.append(NSMenuItem(title: "Quit", action: #selector(didQuit), keyEquivalent: "q"))

        // if item has an action then set the target to self.
        menuItems.forEach({
            if $0.action != nil {
                $0.target = self
            }
        })
        return menuItems
    }
        
    fileprivate func setStatusBarImage(_ isMonoIcon: Bool) -> NSImage{
        let statusbarImage = #imageLiteral(resourceName: "MenuBarColor")
        if isMonoIcon{
            statusbarImage.isTemplate = true
        } else {
            statusbarImage.isTemplate = false
        }
        return statusbarImage
    }
    
    @objc func statusBarMenuUpdate(){
        statusBarItem.isVisible = preferences.showMenu
        let behaviourString: String = preferences.notificationBehaviour.rawValue
        statusBarItem.menu?.item(withTag: 0)?.title = "Notification: \(behaviourString.capitalized)"
        
        if let launchAtLoginIndex = statusBarItem.menu?.indexOfItem(withTarget: self, andAction: #selector(setLaunchAtLogin)){
            statusBarItem.menu?.item(at: launchAtLoginIndex)?.state = preferences.launchAtLogin ? .on : .off
        }
        statusBarItem.button?.image = setStatusBarImage(preferences.isMenuIconMono)
    }
    
    private func didChangePreference(){
        NotificationCenter.default.post(name: .preferencesUpdated, object: nil)
    }
    
    @objc func setLaunchAtLogin(){
        preferences.launchAtLogin.toggle()
        didChangePreference()
    }
    
    @objc func showPerferences(){
        preferencesDelegate?.showPreferences()
    }
    
    @objc func showAbout(){
        aboutDelegate?.showAbout()
    }
    
    @objc func didQuit(){
        NSApp.terminate(self)
    }
}
