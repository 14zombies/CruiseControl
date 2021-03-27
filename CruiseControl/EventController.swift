//
//  EventController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 08/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//
//
import Cocoa

final class EventController: NSObject {
    
    // Controls the event monitors and calls the notificationDelegate when specified event occurs.
    // local and global monitors are necessary as global monitors will not be triggered in foreground.
    
    weak var notificationDelegate: Notifying?
    fileprivate var globalEventMonitor: Any?
    fileprivate var localEventMonitor: Any?
    fileprivate let keyCode: Int
    fileprivate let keyName: String
    
    // key code 57 is for caps lock key, this should allow reuse with a different key press if required.
    init(keyCode: Int, keyName: String) {
        self.keyCode = keyCode
        self.keyName = keyName
        super.init()
        addEventMonitors()
    }

    public func enable() {
        addEventMonitors()
    }

    public func disable() {
        removeEventMonitors()
    }

    fileprivate func addEventMonitors() {
        // Global event monitor for when app is in background
        // Local event monitor for when app is in foreground.
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: flagsChanged)
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: localEventHandler)
    }

    fileprivate func removeEventMonitors() {
        if let globalEventMonitor = globalEventMonitor {
            NSEvent.removeMonitor(globalEventMonitor)
        }
        if let localEventMonitor = localEventMonitor {
            NSEvent.removeMonitor(localEventMonitor)
        }
    }

    fileprivate func localEventHandler(with event: NSEvent) -> NSEvent? {
        flagsChanged(with: event)
        return event
    }

    fileprivate func flagsChanged(with event: NSEvent) {
        if event.keyCode == keyCode {
            let isCapsLockEnabled = event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
            notificationDelegate?.willNotify(keyEnabled: isCapsLockEnabled, keyName: keyName)
        }
    }

}
