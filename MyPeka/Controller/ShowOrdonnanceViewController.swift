//
//  ShowOrdonnanceViewController.swift
//  MyPeka
//
//  Created by Marion RUL on 20/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class ShowOrdonnanceViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var prescriptionPresenter: PrescriptionPresenter!

    /// TableView controlée par "self" qui affiche la collection de "Prescription"
    @IBOutlet weak var prescriptionTable: UITableView!
    
    @IBOutlet weak var dateOrdonnanceLabel: UILabel!
    @IBOutlet weak var docteurLabel: UILabel!
    @IBOutlet weak var nomOrdonnanceLabel: UILabel!
    
    var ordonnance : Ordonnance? = nil
    
    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    fileprivate lazy var prescriptionsFetched : NSFetchedResultsController<Prescription> = {
        // prepare une requête
        let request : NSFetchRequest<Prescription> = Prescription.fetchRequest()
        request.predicate = NSPredicate(format: "ordonnance == %@", self.ordonnance!)
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Prescription.dateDebut), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let oordonnance = self.ordonnance {
            self.nomOrdonnanceLabel.text = oordonnance.nom
            self.docteurLabel.text = oordonnance.docteur?.nom
            self.dateOrdonnanceLabel.text = DateFormat.dateFormatJMAHM(date: oordonnance.datePrescrit!)
        }
        do{
            try self.prescriptionsFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Prescription data management
    
    
    /// Supprime la prescription dont l'index est passé en paramètre
    /// Precondition: Index must be in bound of collection
    /// - Parameter prescriptionWithIndex: Index de la prescription à supprimer
    /// - Returns: True si la prescription a été supprimée
    func delete(prescriptionWithIndex index: IndexPath) -> Bool {
        let context = CoreDataManager.context
        let prescription = self.prescriptionsFetched.object(at: index)
        context.delete(prescription)
        do{
            try context.save()
            return true
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
            return false
        }
    }
    
    // MARK: - NSFetchResultController delegate protocol
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.prescriptionTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.prescriptionTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.prescriptionTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.prescriptionTable.insertRows(at: [newIndexPath], with: .fade)
            }
            
        default:
            break
        }
    }

    
    // MARK: - TableView data source protocole
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.prescriptionTable.dequeueReusableCell(withIdentifier: "prescriptionCell", for: indexPath) as! PrescriptionTableViewCell
        let prescription = self.prescriptionsFetched.object(at: indexPath)
        self.prescriptionPresenter.configure(theCell: cell, forPrescription: prescription)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.prescriptionsFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //Juste gérer l'effacement
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.prescriptionTable.beginUpdates()
            if self.delete(prescriptionWithIndex: indexPath){
                self.prescriptionTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.prescriptionTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    
    let segueShowPrescriptionId = "showPrescriptionSegue"
    let segueAddPrescriptionId = "addPrescriptionSegue"
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show prescription ou la vue add prescription
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowPrescriptionId {
            if let indexPath = self.prescriptionTable.indexPathForSelectedRow {
                let showPrescriptionViewController = segue.destination as! ShowPrescriptionViewController
                showPrescriptionViewController.prescription = self.prescriptionsFetched.object(at: indexPath)
                self.prescriptionTable.deselectRow(at: indexPath, animated: true)
            }
        }
        else if segue.identifier == self.segueAddPrescriptionId{
            let addPrescriptionViewController = segue.destination as! AddPrescriptionViewController
            addPrescriptionViewController.ordonnance = self.ordonnance
        }
    }
    
    /// Indique la destination où on veut retourner
    /// - Parameters:
    ///   - sender : Le segue où on se trouvait
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if sender.identifier == "OkAddPrescriptionSegue" {
            if let controller = sender.source as? AddPrescriptionViewController{
                if let _ = controller.prescription{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    appDelegate.saveContext()
                    self.prescriptionTable.reloadData()
                }
            }
        }
        print("I'm back")
    }


    

    

}
