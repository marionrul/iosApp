//
//  RdvPresenter.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation

class RdvPresenter: NSObject {
    
    fileprivate var date : String = ""
    fileprivate var docteur : String = ""
    
    fileprivate var rdv : RendezVous? = nil {
        didSet{

            if let rdv = self.rdv {
                if let fdate = rdv.date {
                    self.date = DateFormat.dateFormatJMA(date: fdate).capitalized
                }else{
                    self.date = " - "
                }
                if let fdocteur = rdv.docteur?.nom {
                    self.docteur = fdocteur.capitalized
                }
                else{
                    self.docteur = " - "
                }
            }
            else{
                self.date = ""
                self.docteur = ""
            }
        }
    }
    
    func configure (theCell: RdvTableViewCell?, forRdv: RendezVous?){
        self.rdv = forRdv
        guard let cell = theCell else { return }
        cell.docteurLabel.text = self.docteur
        cell.dateLabel.text = self.date

        
    }
    
}
