//
//  ActiviteSportiveExt.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 13/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension ActiviteSportive{
    
    static func getNewActiviteSportiveDAO() -> ActiviteSportive?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "ActiviteSportive", in: moc) else{
            return nil
        }
        return ActiviteSportive(entity: entity, insertInto: moc)
    }
}
