//
//  Ordonnance.swift
//  projetSwift
//
//  Created by Cyril PLUCHE on 20/02/2018.
//  Copyright © 2018 Cyril PLUCHE. All rights reserved.
//

import Foundation

class OrdonnanceModel {
    
    private let dao : Ordonnance
    var nom : String{
        get{
            return self.dao.nom!
        }
        set{
            self.dao.nom = newValue
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
    var datePrescrit : NSDate {
        get{
            return self.dao.datePrescrit!
        }
        set{
            self.dao.datePrescrit = newValue
        }
    }

    var prescriptions = [PrescriptionModel]()
    
    init(nom: String, datePrescrit: NSDate, docteur: Personne) {
        guard let dao = Ordonnance.getNewOrdonnanceDAO() else{
            fatalError("unuable to get dao for Ordonnance")
        }
        self.dao = dao
        self.dao.nom = nom
        self.dao.docteur = docteur
        self.dao.datePrescrit = datePrescrit
    }
    
    func ajouterPrescription (prescription: PrescriptionModel) {
        self.prescriptions.append(prescription)
    }
    
    func supprimerPrescription (prescription: PrescriptionModel) {
        for i in 0...self.prescriptions.count {
            if (self.prescriptions[i] == prescription){
                self.prescriptions.remove(at: i)
            }
        }
    }
    
    func nbPrescriptions() -> Int {
        return self.prescriptions.count
    }
    
}

extension OrdonnanceModel : Equatable{
    
    static func == (lhs: OrdonnanceModel, rhs: OrdonnanceModel) -> Bool {
        return lhs.docteur == rhs.docteur && lhs.prescriptions == rhs.prescriptions
    }
    
    static func != (lhs: OrdonnanceModel, rhs: OrdonnanceModel) -> Bool {
        return !(lhs == rhs)
    }
    
}
