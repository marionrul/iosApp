//
//  ShowActiviteViewController.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 13/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class ShowActiviteViewController: UIViewController {

    @IBOutlet weak var DescriptionLabel: UITextView!
    @IBOutlet weak var NomLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    var activite : ActiviteSportive? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Si une activité a été choisie, on l'affiche
        if let aactivite = self.activite {
            self.DescriptionLabel.text = aactivite.libelle
            self.DescriptionLabel.isEditable = false
            self.NomLabel.text = aactivite.nom
            self.DateLabel.text = DateFormat.dateFormatJMAHM(date: aactivite.date!)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
