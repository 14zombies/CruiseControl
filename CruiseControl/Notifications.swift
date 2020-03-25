//
//  Notifications.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import UserNotifications

final class Notifications: NSObject {

    private let currentNotification = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        currentNotification.delegate = self
    }
   
    fileprivate func sendNotificationError(_ granted: Bool) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .userNotificationError, object: granted)
        }
    }
    
    func notify(message: String, sound: String) {
        currentNotification.requestAuthorization(options: [.sound, .alert]) { [weak self]
            granted, error in
            self?.sendNotificationError(granted)
            
            if granted {
                self?.sendNotification(with: message, soundNamed: sound)
            }
        }
        
    }

    private func sendNotification(with message: String, soundNamed: String) {

        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Cruise Control"
        notificationContent.body = message

        
        let sound = UNNotificationSoundName(soundNamed)
        if soundNamed == "None"{
            notificationContent.sound = nil
        } else {
            notificationContent.sound = UNNotificationSound(named: sound)
        }

        let request = UNNotificationRequest(identifier: Constants.bundleID, content: notificationContent, trigger: nil)
        currentNotification.add(request)

    }
}

extension Notifications: UNUserNotificationCenterDelegate{
    
    //Allows notifications to be delivered while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler(.alert)
    }
}
