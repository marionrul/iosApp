//
//  AddPrescriptionViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 21/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class AddPrescriptionViewController: UIViewController{
    
    @IBOutlet weak var medicamentTextField: UITextField!
    @IBOutlet weak var dateFinPicker: UIDatePicker!
    @IBOutlet weak var dateDebutPicker: UIDatePicker!
    @IBOutlet weak var doseTextField: UITextField!
    
    
    var prescription : PrescriptionModel?
    var ordonnance : Ordonnance? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
      let segueAddPrescriptionId = "OkAddPrescriptionSegue"
    
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show prescription ou la vue add prescription
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OkAddPrescriptionSegue"{
            
            let medicament = self.medicamentTextField.text
            let dose = self.doseTextField.text
            let dateDebut = dateDebutPicker.date
            let dateFin = dateFinPicker.date
            self.prescription = PrescriptionModel(medicament: medicament!, dateDebut: dateDebut as NSDate, dateFin: dateFin as NSDate, dose: dose!, ordonnance: ordonnance!)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            appDelegate.saveContext()
            
            let segueAddPrescriptionId = segue.destination as! AddPriseViewController
            segueAddPrescriptionId.prescription = self.prescription
            segueAddPrescriptionId.prescriptionExist = nil
        }
    }
    
    

}
