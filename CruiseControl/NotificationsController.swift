//
//  NotificationController.swift
//  CruiseControl
//
//  Created by Calum Crawford on 10/03/2020.
//  Copyright © 2020 Calum Crawford. All rights reserved.
//

import Cocoa
import UserNotifications

final class NotificationController: NSObject {
    // The notification controller requests authorisation to display notifications,
    // processes, and sends notifications.
    
    private let currentNotification: UNUserNotificationCenter
    private var notificationState: NotificationPermissionState = .notYetRequested

    init(_ userNotificationCenter: UNUserNotificationCenter) {
        self.currentNotification = userNotificationCenter
        super.init()
        self.currentNotification.delegate = self
        self.checkNotificationSettings()
    }

    public func notify(message: String, sound: String) {
        currentNotification.removeAllDeliveredNotifications()
        if notificationState.isEnabled() {
            self.sendNotification(with: message, sound: sound)
        }
    }

    fileprivate func didChangeNotificationAuthorization(_ granted: Bool) {
        self.checkNotificationSettings()
    }

    fileprivate func requestAuthorization() {
        currentNotification.requestAuthorization(options: [.provisional, .sound, .alert]) { (granted, _) in
            self.didChangeNotificationAuthorization(granted)
        }
    }

    private func checkNotificationSettings() {
        currentNotification.getNotificationSettings { [weak self] (settings) in
            guard let self = self else { return }
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .denied:
                self.notificationState = .notAvailable
            case .authorized:
                self.notificationState = .available
            case .provisional:
                self.notificationState = .available
            default:
                break
            }
        }
    }

    private func createNotification(with message: String, sound soundName: String) -> UNMutableNotificationContent {
        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        
        // App Name is shown as title already on Big Sur, so we don't need to include it.
        if #available(macOS 11.0, *) {} else {
            notificationContent.title = Constants.appName
        }
        notificationContent.body = message

        if soundName == "None"{
            notificationContent.sound = nil
        } else {
            notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(soundName))
        }
        return notificationContent
    }

    private func sendNotification(with message: String, sound soundName: String) {
        let notificationContent = self.createNotification(with: message, sound: soundName)
        let request = UNNotificationRequest(identifier: Constants.mainBundleID, content: notificationContent, trigger: nil)
        currentNotification.add(request)
    }
}

extension NotificationController: UNUserNotificationCenterDelegate {

    // Allows notifications to be delivered while app is in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions)
                                -> Void) {
        completionHandler([.list, .banner, .sound])
    }

}
