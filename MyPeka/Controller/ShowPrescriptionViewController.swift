//
//  ShowPrescriptionViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 21/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class ShowPrescriptionViewController: UIViewController {

    @IBOutlet weak var dateFinLabel: UILabel!
    @IBOutlet weak var dateDebutLabel: UILabel!
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var medicamentLabel: UILabel!
    
    var prescription : Prescription? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pprescription = self.prescription {
            self.dateFinLabel.text = DateFormat.dateFormatJMAHM(date: pprescription.dateFin!)
            self.dateDebutLabel.text = DateFormat.dateFormatJMAHM(date: pprescription.dateDebut!)
            self.doseLabel.text = pprescription.dose
            self.medicamentLabel.text = pprescription.medicament
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    let segueAddPrescriptionId = "OkUpdatePrescriptionSegue"
    
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show prescription ou la vue add prescription
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OkUpdatePrescriptionSegue"{
            let segueAddPrescriptionId = segue.destination as! AddPriseViewController
            segueAddPrescriptionId.prescriptionExist = self.prescription
            
        }
    }


}
