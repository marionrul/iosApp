//
//  ActivitePresenter.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class ActivitePresenter: NSObject {
    
    fileprivate var nom : String = ""
    fileprivate var date : String = ""
    fileprivate var libelle : String = ""
    
    fileprivate var activite : ActiviteSportive? = nil {
        didSet{
            if let activite = self.activite {
                if let fnom = activite.nom{
                    if activite.nom != "" {
                        self.nom = fnom.capitalized
                    }else{
                        self.nom = "Activité"
                    }
                }
                else{
                    self.nom = "Activité"
                }
                if let fdate = activite.date {
                    self.date = DateFormat.dateFormatJMA(date: fdate).capitalized
                }else{
                    self.date = " - "
                }
                if let flibelle = activite.libelle {
                    if activite.libelle != "" {
                        self.libelle = flibelle.capitalized
                    }else {
                        self.libelle = "Pas de description pour cette activité."
                    }
                }
                else{
                    self.libelle = " Pas de description pour cette activité."
                }
            }
            else{
                self.nom = ""
                self.date = ""
                self.libelle = ""
            }
        }
    }
    
    func configure (theCell: ActiviteTableViewCell?, forActivite: ActiviteSportive?){
        self.activite = forActivite
        guard let cell = theCell else { return }
        cell.nomLabel.text = self.nom
        cell.dateLabel.text = self.date
    }
    
}
