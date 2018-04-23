//
//  ActiviteSportive.swift
//  projetSwift
//
//  Created by Cyril PLUCHE on 20/02/2018.
//  Copyright © 2018 Cyril PLUCHE. All rights reserved.
//

import Foundation
class ActiviteSportiveModel  {
    
    private let dao : ActiviteSportive
    var nom : String{
        get{
            return self.dao.nom! // On peut forcer car init avec paramètre
        }
        set{
            self.dao.nom = newValue
        }
    }
    var date : NSDate{
        get{
            return self.dao.date!
        }
        set{
            self.dao.date = newValue
        }
    }
    var description : String?{
        get{
            return self.dao.libelle
        }
        set{
            self.dao.libelle = newValue
        }
    }
    var estRealisee : Bool = false
    
    init(nom : String, description: String, date : NSDate) {
        guard let dao = ActiviteSportive.getNewActiviteSportiveDAO() else{
            fatalError("unuable to get dao for ActiviteSportive")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.date = date
        self.dao.libelle = description
        
    }
    
    func validerActivite (valider : Bool) {
        
    }
    
}
