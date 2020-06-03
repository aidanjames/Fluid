//
//  NotificationManager.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 06/05/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                // Good to go
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func scheduleTimerStillRunningNotification(for taskName: String) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = "Timer still running"
            content.subtitle = "You're still logging time for \(taskName)"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            self.center.add(request)
        }
    }
    
    func scheduleBreakFinishedNotification(withID id: String = UUID().uuidString, timeInterval: Double) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = "Break's over!"
            content.subtitle = "Time to get back to work"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            self.center.add(request)
        }
    }
    
    
    func scheduleSessionFinishedNotification(withID id: String = UUID().uuidString, timeInterval: Double) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }
            let content = UNMutableNotificationContent()
            content.title = "Pomodoro session done!"
            content.subtitle = "Time for a break"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            self.center.add(request)
        }
    }
    
    
    func cancelAllNotificaitons() {
        center.removeAllPendingNotificationRequests()
    }
    
    
}
