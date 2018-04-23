//
//  RendezVousModel.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class RendezVousModel  {
    
    private let dao : RendezVous
    var libelle : String{
        get{
            return self.dao.libelle! // On peut forcer car init avec paramètre
        }
        set{
            self.dao.libelle = newValue
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
    
    var docteur : Personne? {
        get{
            return self.dao.docteur!
        }
        set{
            self.dao.docteur = newValue
        }
    }
        
    init(libelle : String, date : NSDate, docteur: Personne) {
        guard let dao = RendezVous.getNewRendezVousDAO() else{
            fatalError("unuable to get dao for RendezVous")
        }
        self.dao = dao
        self.dao.libelle = libelle
        self.dao.date = date
        self.dao.docteur = docteur
    }

}
