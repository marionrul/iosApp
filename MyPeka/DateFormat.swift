//
//  dateFormat.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit

class DateFormat {
    
  
    /// Transforme la date au format "jj-mm-aaaa"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatJMA (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "jj-mm-aaaa hh:mm"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatJMAHM (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "hh:mm"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func heureFormatHM (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "jj"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatJ (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "mm"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatM (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "aaaa"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatA (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "hh"
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatH (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    /// Transforme la date au format "mm" (minutes)
    ///
    /// - Parameter date: La NSDate que l'on veut formater
    /// - Returns: La nouvelle date en String
    static func dateFormatMin (date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
}
