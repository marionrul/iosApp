//
//  PriseExt.swift
//  MyPeka
//
//  Created by Marion RUL on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension Prise{
    
    static func getNewPriseDAO() -> Prise?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let moc = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Prise", in: moc) else{
            return nil
        }
        return Prise(entity: entity, insertInto: moc)
    }
}
