//
//  ActivityNotificationCenter.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 27/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class ActivityNotificationCenter {
    
    /// Programmer une notification dans x secondes
    static func activityNotification (nameActivity: String, libelleActivity: String, inSeconds: TimeInterval){
        
        /// Trigger qui déclenche la notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        /// Le contenu à afficher dans la notification
        let content = UNMutableNotificationContent()
        content.title = nameActivity
        content.body = libelleActivity
        
        let randomNumber = arc4random() % 1000000
        
         /// Requête de notification créée avec le contenu et le trigger
        let request = UNNotificationRequest(identifier: String(describing: randomNumber), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("false")
            }else {
                print("true")
            }
        }
    }
    
      /// Calcule l'intervalle de temps en secondes entre la date actuelle et la date donnée
    static func calculSeconds(forDate: Date) -> TimeInterval {
        let interval = forDate.timeIntervalSince(Date())
        return interval
    }
    
    static func programmedAllNotificationActivity(nameActivity: String, libelleActivity: String, forDate: Date) {
        
        var component = DateComponents()
        component.calendar = Calendar.current
        component.year     = Int(DateFormat.dateFormatA(date: forDate as NSDate))
        component.month    = Int(DateFormat.dateFormatM(date: forDate as NSDate))
        component.day      = Int(DateFormat.dateFormatJ(date: forDate as NSDate))
        component.hour = Int(DateFormat.dateFormatH(date: forDate as NSDate))
        component.minute = Int(DateFormat.dateFormatMin(date: forDate as NSDate))
        
        let inSeconds = calculSeconds(forDate: component.date!)
        self.activityNotification(nameActivity: nameActivity, libelleActivity: libelleActivity, inSeconds: inSeconds)
        
    }
}
