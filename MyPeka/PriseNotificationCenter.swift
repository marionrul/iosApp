//
//  NotificationCenter.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 27/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PriseNotificationCenter {
    
   /// Programmer une notification dans x secondes
    static func priseNotification (forPrise: Prise, inSeconds: TimeInterval){
        
        /// Trigger qui déclenche la notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        /// Le contenu à afficher dans la notification
        let content = UNMutableNotificationContent()
        content.title = (forPrise.prescription?.ordonnance?.nom)!
        content.subtitle = (forPrise.prescription?.medicament)!
        content.body = (forPrise.prescription?.dose)!
        
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
    
    static func programmedAllNotificationPrise (forPrise: Prise, forDate: Date) {
        let dateDebut = forPrise.prescription?.dateDebut
        let dateFin = forPrise.prescription?.dateFin
        
        //Durée en secondes
        let dureeS = dateFin?.timeIntervalSince(dateDebut! as Date)
        //Durée en jours
        let dureeJ = dureeS!/(60*60*24)
        
        
        var component = DateComponents()
        component.calendar = Calendar.current
        component.year     = Int(DateFormat.dateFormatA(date: dateDebut!))
        component.month    = Int(DateFormat.dateFormatM(date: dateDebut!))
        component.day      = Int(DateFormat.dateFormatJ(date: dateDebut!))
        component.hour = Int(DateFormat.dateFormatH(date: forDate as NSDate))
        component.minute = Int(DateFormat.dateFormatMin(date: forDate as NSDate))
        
        for _ in 0...Int(dureeJ) {
            let inSeconds = calculSeconds(forDate: component.date!)
            self.priseNotification(forPrise: forPrise, inSeconds: inSeconds)
            component.day! += 1
        }
        
        
        
    }
}
