//
//  CoreDataManager.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 13/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    /// Retourne le contexte de l'application
    static var context : NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            exit(EXIT_FAILURE)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    @discardableResult
    class func save() -> NSError? {
        // try to save it
        do{
            try CoreDataManager.context.save()
            return nil
        }
        catch let error as NSError{
            return error
        }
    }
    
}
