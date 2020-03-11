//
//  Events.swift
//  CruiseControl
//
//  Created by Calum Crawford on 08/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa

class Events: NSObject{
    
    weak var notificationDelegate: Notifying?
    fileprivate var globalEventMonitor: Any?
    fileprivate var localEventMonitor: Any?
    
    override init() {
        super.init()
        addEventMonitor()
    }

    fileprivate func isCapslockEnabled(with event: NSEvent) -> Bool {
            event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
    }
    
    fileprivate func flagsChanged(with event: NSEvent) {
        if event.keyCode == 57 {
            notificationDelegate?.willNotify(capsLockEnabled: isCapslockEnabled(with: event))
        }
    }
    
    fileprivate func localEventHandler(with event: NSEvent) -> NSEvent? {
        flagsChanged(with: event)
        return event
    }
    
    public func enable(){
        addEventMonitor()
    }
    
    public func disable(){
        removeEventMonitor()
    }
    
    fileprivate func addEventMonitor(){
        //Global event monitor for when app is in background
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: flagsChanged)
        
        //Local event monitor for when app is in foreground.
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged, handler: localEventHandler)
        
    }
    
    fileprivate func removeEventMonitor(){
        if let globalEventMonitor = globalEventMonitor {
            NSEvent.removeMonitor(globalEventMonitor)
        }
        if let localEventMonitor = localEventMonitor {
            NSEvent.removeMonitor(localEventMonitor)
        }
        
    }
    
    
   
}

