//
//  PrescriptionPresenter.swift
//  MyPeka
//
//  Created by Marion RUL on 21/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class PrescriptionPresenter: NSObject {
    
    fileprivate var medicament : String = ""
    
    fileprivate var prescription : Prescription? = nil {
        didSet{
            if let prescription = self.prescription {
                if let fmedicament = prescription.medicament {
                    self.medicament = fmedicament.capitalized
                }
                else{
                    self.medicament = " - "
                }
            }
        }
    }
    
    func configure (theCell: PrescriptionTableViewCell?, forPrescription: Prescription?){
        self.prescription = forPrescription
        guard let cell = theCell else { return }
        cell.medicamentLabel.text = self.medicament
    }
    
}
