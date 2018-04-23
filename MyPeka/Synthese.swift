//
//  Synthese.swift
//  projetSwift
//
//  Created by Cyril PLUCHE on 20/02/2018.
//  Copyright © 2018 Cyril PLUCHE. All rights reserved.
//

import Foundation

class Synthese {

    var dateDebut : Date
    
    // On déclare des matrices pour avoir les synthèse et évènements sur 5 jours.
    var syntheses = [[String]]()
    var evenements = [[String]]()
    
    var questions = [String](repeating: "-", count: 5)

    init(dateDebut : Date) {
        self.dateDebut = dateDebut
    }
    
    func ajouterSymptome (symptome: String) {
        
        // On declare un formateur pour recuperer seulement une partie de la date
        let format = DateFormatter()
        format.dateFormat = "HH"
        
        // On recupere l'heure du symptome
        let heure = Int(format.string(from: Date()))

        // On recupere le jour du symptome
        format.dateFormat = "dd"
        let jour = Int(format.string(from: Date()))
        
        // On recupere le jour du debut de la synthese
        let jourDebut = Int(format.string(from: dateDebut))

        // On calcule les indices pour pouvoir ajouter le symptome au bon endroit dans la matrice
        let i : Int = jour! - jourDebut!
        let j : Int = heure!
        
        syntheses[i][j].append(symptome)
        
    }
    
}
