//
//  Prescription.swift
//  projetSwift
//
//  Created by Cyril PLUCHE on 20/02/2018.
//  Copyright © 2018 Cyril PLUCHE. All rights reserved.
//

import Foundation

class PrescriptionModel {
    
    private let dao : Prescription
    
    var medicament : String {
        get{
            return self.dao.medicament!
        }
        set{
            self.dao.medicament = newValue
        }
    }
    
    
    var dateDebut : NSDate {
        get{
            return self.dao.dateDebut!
        }
        set{
            self.dao.dateDebut = newValue
        }
    }
    var dateFin : NSDate {
        get{
            return self.dao.dateFin!
        }
        set{
            self.dao.dateFin = newValue
        }
    }
    var dose : String {
        get{
            return self.dao.dose!
        }
        set{
            self.dao.dose = newValue
        }
    }

    
    init(medicament : String, dateDebut : NSDate, dateFin : NSDate, dose : String, ordonnance: Ordonnance) {
        guard let dao = Prescription.getNewPrescriptionDAO() else{
            fatalError("unuable to get dao for Prescription")
        }
        self.dao = dao
        self.dao.medicament = medicament
        self.dao.dateDebut = dateDebut
        self.dao.dateFin = dateFin
        self.dao.dose = dose
        self.dao.ordonnance = ordonnance
    }
    
}

extension PrescriptionModel : Equatable{
    
    static func == (lhs: PrescriptionModel, rhs: PrescriptionModel) -> Bool {
        return lhs.medicament == rhs.medicament && lhs.dateDebut == rhs.dateDebut && lhs.dateFin == rhs.dateFin &&
               lhs.dose == rhs.dose
    }
    
    static func != (lhs: PrescriptionModel, rhs: PrescriptionModel) -> Bool {
        return !(lhs == rhs)
    }
}
