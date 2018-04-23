//
//  AddActivityViewController.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 13/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    @IBOutlet weak var dateP: UIDatePicker!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var nomTextField: UITextField!
    
    var activite : ActiviteSportiveModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show prescription ou la vue add prescription
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OkAddActivitySegue"{
            let nom = self.nomTextField.text
            let date = self.dateP.date
            let description = self.descriptionView.text
            self.activite = ActiviteSportiveModel(nom: nom!, description: description!, date: date as NSDate)
        }
    }

}
