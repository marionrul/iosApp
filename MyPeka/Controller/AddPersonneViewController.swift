//
//  AddPersonneViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 21/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit

class AddPersonneViewController: UIViewController {

    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var specialiteTextField: UITextField!
    @IBOutlet weak var villeTextField: UITextField!
    @IBOutlet weak var rueTextField: UITextField!
    @IBOutlet weak var numeroRueTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    
    var docteur : PersonneModel?
    
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
        if segue.identifier == "OkAddPersonneSegue"{
            let nom = self.nomTextField.text
            let prenom = self.prenomTextField.text
            let specialite = specialiteTextField.text
            let rue = rueTextField.text
            let numeroRue = numeroRueTextField.text
            let ville = villeTextField.text
            let telephone: Int? = Int(telTextField.text!)
            self.docteur = PersonneModel(nom: nom!, prenom: prenom!, rue: rue!, numeroRue: numeroRue!, ville: ville!, tel: telephone!, specialite: specialite!)
        }
    }


}
