//
//  AddPriseViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class AddPriseViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, NSFetchedResultsControllerDelegate {
    
    ///TableView controlée par "self" qui affiche la collection de "Prise"
    @IBOutlet weak var priseTable: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var prisePresenter: PrisePresenter!
    
    var prise : PriseModel?
    var prescription : PrescriptionModel?
    var prescriptionExist : Prescription?

    
    @IBAction func addPrise(_ sender: Any) {
        let date = self.datePicker.date
        let prescription : Prescription
        prescription = (self.prescriptionFetched.fetchedObjects?[0])!
        self.prise = PriseModel(date: date as NSDate, prescription: prescription)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        appDelegate.saveContext()
        

        do{
            try self.prisesFetched.performFetch()
            self.priseTable.reloadData()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }

        
        self.priseTable.reloadData()
        do{
            try self.priseFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }

        PriseNotificationCenter.programmedAllNotificationPrise(forPrise: (self.priseFetched.fetchedObjects?[0])!, forDate: self.datePicker.date)
        
        
    }
    
    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    /// Permet de récupérer la prise qui vient d'être ajoutée pour pouvoir créer la notification associée
    fileprivate lazy var priseFetched : NSFetchedResultsController<Prise> = {
        // prepare une requête
        let request : NSFetchRequest<Prise> = Prise.fetchRequest()
        request.predicate = NSPredicate(format: "prescription == %@ AND date == %@", (self.prescriptionFetched.fetchedObjects?[0])!, self.datePicker.date as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Prise.date), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    
    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    /// Permet de récupérer toutes les prises du CoreData pour les afficher dans la TableView
    fileprivate lazy var prisesFetched : NSFetchedResultsController<Prise> = {
        // prepare une requête
        let request : NSFetchRequest<Prise> = Prise.fetchRequest()
        request.predicate = NSPredicate(format: "prescription == %@", (self.prescriptionFetched.fetchedObjects?[0])!)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Prise.date), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    /// Permet de récupérer la prescription correspondant aux prises à ajouter, pour pouvoir faire l'envoi dans PriseModel
    fileprivate lazy var prescriptionFetched : NSFetchedResultsController<Prescription> = {
        // prepare une requête
        let request : NSFetchRequest<Prescription> = Prescription.fetchRequest()
        //Si self.prescriptionExist == nil Alors j'ai été appelé par la page AddPrescriptionViewController, donc je dois récupérer la prescription que je viens de créer pour pouvoir ajouter des prises.
        if (self.prescriptionExist == nil){
            request.predicate = NSPredicate(format: "dateDebut == %@ AND dateFin == %@ AND dose == %@ AND medicament == %@", self.prescription!.dateDebut, self.prescription!.dateFin, self.prescription!.dose, self.prescription!.medicament)
        }
        // Sinon, je proviens de la page ShowPrescriptionViewController, et je dois ainsi récupérer la bonne prescription qui correspond à celle que je veux modifier. En effet, il faut une Prescription et non une PrescriptionModel pour faire des ajouts dans le CoreData
        else{
            request.predicate = NSPredicate(format: "dateDebut == %@ AND dateFin == %@ AND dose == %@ AND medicament == %@", self.prescriptionExist!.dateDebut!, self.prescriptionExist!.dateFin!, self.prescriptionExist!.dose!, self.prescriptionExist!.medicament!)
        }
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Prescription.dateDebut), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try self.prescriptionFetched.performFetch()

            try self.prisesFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Prise data management
    
    
    /// Supprime la prise dont l'index est passé en paramètre
    /// Precondition: Index must be in bound of collection
    /// - Parameter priseWithIndex: Index de la prise à supprimer
    /// - Returns: True si le prise a été supprimée
    func delete(priseWithIndex index: IndexPath) -> Bool {
        let context = CoreDataManager.context
        let prise = self.prisesFetched.object(at: index)
        context.delete(prise)
        do{
            try context.save()
            return true
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
            return false
        }
    }
    
    func save() {
        if let error = CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
    }

    // MARK: - NSFetchResultController delegate protocol
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.priseTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.priseTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.priseTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.priseTable.insertRows(at: [newIndexPath], with: .fade)
            }
            
        default:
            break
        }
    }

    
    // MARK: - TableView data source protocole
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.priseTable.dequeueReusableCell(withIdentifier: "priseCell", for: indexPath) as! PriseTableViewCell
        let prise = self.prisesFetched.object(at: indexPath)
        //self.prisePresenter.configure(theCell: cell, forPrise: prise)
        cell.textLabel?.text = DateFormat.heureFormatHM(date: (prise.date)!).capitalized

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.prisesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //Pour gérer la suppression
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.priseTable.beginUpdates()
            if self.delete(priseWithIndex: indexPath){
                self.priseTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.priseTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
