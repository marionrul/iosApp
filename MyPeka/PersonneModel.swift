//
//  File.swift
//  projetSwift
//
//  Created by Cyril PLUCHE on 20/02/2018.
//  Copyright © 2018 Cyril PLUCHE. All rights reserved.
//

import Foundation

class PersonneModel {
    
    private let dao : Personne
    
    // Identité
    var nom : String {
        get{
            return self.dao.nom!
        }
        set{
            self.dao.nom = newValue
        }
    }
    var prenom : String{
        get{
            return self.dao.prenom!
        }
        set{
            self.dao.prenom = newValue
        }
    }

    
    // Adresse
    var rue : String {
        get{
            return self.dao.rue!
        }
        set{
            self.dao.rue = newValue
        }
    }
    var numeroRue : String {
        get{
            return self.dao.numeroRue!
        }
        set{
            self.dao.numeroRue = newValue
        }
    }
    var ville : String {
        get{
            return self.dao.ville!
        }
        set{
            self.dao.ville = newValue
        }
    }

    
    // Coordonnées
    var tel : Int {
        get{
            return Int(self.dao.tel)
        }
        set{
            self.dao.tel = Int64(newValue)
        }
    }
    var specialite : String {
        get{
            return self.dao.specialite!
        }
        set{
            self.dao.specialite = newValue
        }
    }

    
    init(nom : String, prenom : String, rue : String, numeroRue : String, ville : String, tel : Int, specialite : String){
        guard let dao = Personne.getNewPersonneDAO() else{
            fatalError("unuable to get dao for Personne")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.prenom = prenom
        self.dao.rue = rue
        self.dao.numeroRue = numeroRue
        self.dao.ville = ville
        self.dao.tel = Int64(tel)
        self.dao.specialite = specialite
    }
}

extension PersonneModel : Equatable{
    
    static func == (lhs: PersonneModel, rhs: PersonneModel) -> Bool {
        // A faire avec les id plus tard
        return lhs.nom == rhs.nom
    }
    
    static func != (lhs: PersonneModel, rhs: PersonneModel) -> Bool {
        return !(lhs == rhs)
    }
}
