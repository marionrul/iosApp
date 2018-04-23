//
//  PrescriptionExt.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension Prescription{
    
    static func getNewPrescriptionDAO() -> Prescription?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Prescription", in: moc) else{
            return nil
        }
        return Prescription(entity: entity, insertInto: moc)
    }
    
    
}
