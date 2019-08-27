//
//  LocalPushManager.swift
//  InstagramClone
//
//  Created by Teknasyon-S on 24.12.2018.
//  Copyright © 2018 Hazal Eroglu. All rights reserved.
//

import Foundation
import UserNotifications

class LocalPushManager: NSObject {
    static var shared = LocalPushManager()
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error == nil {
                print("HELLO")
            }
        }
    }
    
    func sendLocalPush(in time: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Following", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Follow button clicked", arguments: nil)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error)
            if error == nil {
                print("error")
            }
        }
    }
}
