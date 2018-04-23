//
//  ShowRdvViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class ShowRdvViewController: UIViewController {
    
    @IBOutlet weak var libelleMabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nomDocteur: UILabel!
    @IBOutlet weak var nRue: UILabel!
    @IBOutlet weak var rue: UILabel!
    @IBOutlet weak var villeLabel: UILabel!

    var rdv : RendezVous? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rrdv = self.rdv {
            self.libelleMabel.text = rrdv.libelle
            self.dateLabel.text = DateFormat.dateFormatJMAHM(date: rrdv.date!)
            self.nomDocteur.text = rrdv.docteur?.nom
            self.nRue.text = rrdv.docteur?.numeroRue
            self.rue.text = rrdv.docteur?.rue
            self.villeLabel.text = rrdv.docteur?.ville
            
        }

        // Do any additional setup after loading the view.
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
