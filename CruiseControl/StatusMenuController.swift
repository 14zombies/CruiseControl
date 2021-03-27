//
//  StatusMenuController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

final class StatusMenuController {
    
    // Builds Status Menu and responds to events from said menu.
    
    weak var preferencesDelegate: PreferencesShowing?
    weak var aboutDelegate: AboutShowing?

    private var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var preferences: Preferences

    init(prefs: Preferences) {
        self.preferences = prefs
        menuSetup()
        self.subscribe(#selector(statusMenuUpdate))
    }

    fileprivate func menuSetup() {
        statusBarItem.menu = NSMenu(title: "\(Constants.appName) Status Bar Menu")
        statusBarItem.menu?.items = buildMenuItems()
        statusMenuUpdate()
    }

    // Builds items for status icon menu.
    fileprivate func buildMenuItems() -> [NSMenuItem] {
        var menuItems = [NSMenuItem]()

        let notificationItem = NSMenuItem(title: "Notification: \(preferences.notificationBehaviour)",
                                          action: nil, keyEquivalent: "")
        notificationItem.tag = 0
        menuItems.append(notificationItem)
        menuItems.append(.separator())
        menuItems.append(NSMenuItem(title: "Launch At Login", action: #selector(setLaunchAtLogin), keyEquivalent: ""))
        menuItems.append(NSMenuItem(title: "Preferences…", action: #selector(showPreferences), keyEquivalent: ","))
        menuItems.append(.separator())
        menuItems.append(NSMenuItem(title: "About \(Constants.appName)",
                                    action: #selector(showAbout),
                                    keyEquivalent: ""))
        menuItems.append(NSMenuItem(title: "Quit", action: #selector(didQuit), keyEquivalent: "q"))

        // if item has an action then set the target to self otherwise items will do nothing when clicked.
        menuItems.forEach({
            if $0.action != nil {
                $0.target = self
            }
        })
        return menuItems
    }

    fileprivate func setStatusMenuImage(_ isMonoIcon: Bool) -> NSImage {
        let statusMenuImage = #imageLiteral(resourceName: "MenuBarColor")
        if isMonoIcon {
            statusMenuImage.isTemplate = true
        } else {
            statusMenuImage.isTemplate = false
        }
        return statusMenuImage
    }

    @objc func statusMenuUpdate() {
        statusBarItem.isVisible = preferences.showMenu
        let behaviourString: String = preferences.notificationBehaviour.rawValue
        statusBarItem.menu?.item(withTag: 0)?.title = "Notification: \(behaviourString.capitalized)"

        if let launchAtLoginIndex = statusBarItem.menu?.indexOfItem(withTarget: self,
                                                                    andAction: #selector(setLaunchAtLogin)) {
            statusBarItem.menu?.item(at: launchAtLoginIndex)?.state = preferences.launchAtLogin ? .on : .off
        }
        statusBarItem.button?.image = setStatusMenuImage(preferences.isMonoIcon)
    }

    @objc func setLaunchAtLogin() {
        preferences.launchAtLogin.toggle()
    }

    @objc func showPreferences() {
        preferencesDelegate?.showPreferences()
    }

    @objc func showAbout() {
        aboutDelegate?.showAbout()
    }

    @objc func didQuit() {
        NSApp.terminate(self)
    }
}

extension StatusMenuController: PreferencesDisplaying {}
