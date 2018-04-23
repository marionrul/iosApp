//
//  RendezVousExt.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension RendezVous{
    
    static func getNewRendezVousDAO() -> RendezVous?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "RendezVous", in: moc) else{
            return nil
        }
        return RendezVous(entity: entity, insertInto: moc)
    }
}
