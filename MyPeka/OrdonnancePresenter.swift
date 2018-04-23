//
//  OrdonnancePresenter.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 19/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class OrdonnancePresenter: NSObject {
    
    fileprivate var nom : String = ""
    fileprivate var date : String = ""
    fileprivate var docteur : String = ""
    
    fileprivate var ordonnance : Ordonnance? = nil {
        didSet{
            if let ordonnance = self.ordonnance {
                if let fnom = ordonnance.nom {
                    self.nom = fnom.capitalized
                }
                else{
                    self.nom = " - "
                }
                if let fdate = ordonnance.datePrescrit {
                    self.date = DateFormat.dateFormatJMA(date: fdate).capitalized
                }else{
                    self.date = " - "
                }
                if let fdocteur = ordonnance.docteur?.nom {
                    self.docteur = fdocteur.capitalized
                }
                else{
                    self.docteur = " - "
                }
            }
            else{
                self.nom = ""
                self.date = ""
                self.docteur = ""
            }
        }
    }
    
    func configure (theCell: OrdonnanceTableViewCell?, forOrdonnance: Ordonnance?){
        self.ordonnance = forOrdonnance
        guard let cell = theCell else { return }
        cell.NomLabel.text = self.nom
        cell.DateLabel.text = self.date
        cell.DocteurLabel.text = self.docteur
    }
    
}
