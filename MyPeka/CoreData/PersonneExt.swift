//
//  PersonneExt.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension Personne{
    
    static func getNewPersonneDAO() -> Personne?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Personne", in: moc) else{
            return nil
        }
        return Personne(entity: entity, insertInto: moc)
    }
}
