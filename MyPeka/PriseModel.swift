//
//  PriseModel.swift
//  MyPeka
//
//  Created by Marion RUL on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class PriseModel  {
    
    private let dao : Prise

    var date : NSDate{
        get{
            return self.dao.date!
        }
        set{
            self.dao.date = newValue
        }
    }
    
    
    init(date : NSDate, prescription: Prescription) {
        guard let dao = Prise.getNewPriseDAO() else{
            fatalError("unuable to get dao for RendezVous")
        }
        self.dao = dao
        self.dao.date = date
        self.dao.prescription = prescription
    }
    
}
