//
//  AddRdvViewController.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class AddRdvViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate {

    var rdv : RendezVousModel?
    var docteur : Personne?

  
    @IBOutlet weak var docteurPickerA: UIPickerView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var libelleTextField: UITextField!
    
    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    fileprivate lazy var personnesFetched : NSFetchedResultsController<Personne> = {
        // prepare une requête
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Personne.nom), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do{
            try self.personnesFetched.performFetch()
            self.docteurPickerA.reloadAllComponents()
        }
        catch let error as NSError{
            fatalError(error.description)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PickerView data source protocole
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //guard let sections = self.personnesFetched.sections else { return 0 }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let sections = self.personnesFetched.sections?[component] else { return 0 }
        if (self.personnesFetched.fetchedObjects?.isEmpty)! {
            return 1
        }

        return sections.numberOfObjects
    }
    
    // MARK: - PickerView delegate protocol
    
    /// Called by the picker view when it needs the title to use for a given row in a given component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if !(self.personnesFetched.fetchedObjects?.isEmpty)! {
            let person = self.personnesFetched.object(at: IndexPath(row: row, section: component))
            return person.nom
        }
        else{return "Aucun Docteur" }        
    }

    

    // MARK: - Navigation
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show prescription ou la vue add prescription
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OkAddRdvSegue"{
            
            let libelle = self.libelleTextField.text
            let date = datePicker.date
            let indiceDocteur = self.docteurPickerA.selectedRow(inComponent: 0)
            self.docteur = personnesFetched.fetchedObjects![indiceDocteur]

            self.rdv = RendezVousModel(libelle: libelle!, date: date as NSDate, docteur: docteur!)
        }
    }
    
    /// Indique la destination où on veut retourner
    /// - Parameters:
    ///   - sender : Le segue où on se trouvait
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if sender.identifier == "OkAddPersonneSegue" {
            if let controller = sender.source as? AddPersonneViewController{
                if let _ = controller.docteur{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    appDelegate.saveContext()
                    
                    do{
                        try self.personnesFetched.performFetch()
                        self.docteurPickerA.reloadAllComponents()
                    }
                    catch let error as NSError{
                        fatalError(error.description)
                    }
                    self.docteurPickerA.reloadAllComponents()
                }
            }
        }
        print("I'm back")
    }
    
    


}
