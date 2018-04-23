//
//  PrisePresenter.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 27/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
class PrisePresenter: NSObject {
    
    fileprivate var date : String = ""
    
    fileprivate var prise : Prise? = nil {
        didSet{
            
            if let prise = self.prise {
                if let fdate = prise.date {
                    self.date = DateFormat.dateFormatJMA(date: fdate).capitalized                }
                else{
                    self.date = " - "
                }
            }
            else{
                self.date = ""
            }
        }
    }
    
    func configure (theCell: PriseTableViewCell?, forPrise: Prise?){
        self.prise = forPrise
        guard let cell = theCell else { return }
        cell.dateLabel.text = self.date
    }
    
}
