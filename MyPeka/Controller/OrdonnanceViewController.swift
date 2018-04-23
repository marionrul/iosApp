//
//  OrdonnanceViewController.swift
//  MyPeka
//
//  Created by Polytech on 14/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class OrdonnanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var OrdonnancePresenter: OrdonnancePresenter!
    
    /// TableView controlée par "self" qui affiche la collection d'"Ordonnance"
    @IBOutlet weak var ordonnanceTable: UITableView!

    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    fileprivate lazy var ordonnancesFetched : NSFetchedResultsController<Ordonnance> = {
        // prepare une requête
        let request : NSFetchRequest<Ordonnance> = Ordonnance.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Ordonnance.datePrescrit), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try self.ordonnancesFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Ordonnance data management
    
    
    /// Supprime l'ordonnance dont l'index est passé en paramètre
    /// Precondition: Index must be in bound of collection
    /// - Parameter ordonnanceWithIndex: Index de l'ordonnance à supprimer
    /// - Returns: True si l'ordonnance a été supprimée
    func delete(ordonnanceWithIndex index: IndexPath) -> Bool {
        let context = CoreDataManager.context
        let ordonnance = self.ordonnancesFetched.object(at: index)
        context.delete(ordonnance)
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
        self.ordonnanceTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.ordonnanceTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.ordonnanceTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.ordonnanceTable.insertRows(at: [newIndexPath], with: .fade)
            }
            
        default:
            break
        }
    }

    
    
    // MARK: - TableView data source protocole
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ordonnanceTable.dequeueReusableCell(withIdentifier: "ordonnanceCell", for: indexPath) as! OrdonnanceTableViewCell
        let ordonnance = self.ordonnancesFetched.object(at: indexPath)
        self.OrdonnancePresenter.configure(theCell: cell, forOrdonnance: ordonnance)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.ordonnancesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //Juste gérer l'effacement
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.ordonnanceTable.beginUpdates()
            if self.delete(ordonnanceWithIndex: indexPath){
                self.ordonnanceTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.ordonnanceTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    // MARK: - Navigation
    
    let segueShowOrdonnanceId = "showOrdonnanceSegue"
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show ordonnance
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowOrdonnanceId {
            if let indexPath = self.ordonnanceTable.indexPathForSelectedRow {
                let showOrdonnanceViewController = segue.destination as! ShowOrdonnanceViewController
                showOrdonnanceViewController.ordonnance = self.ordonnancesFetched.object(at: indexPath)
                self.ordonnanceTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    /// Indique la destination où on veut retourner
    /// - Parameters:
    ///   - sender : Le segue où on se trouvait
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if sender.identifier == "OkAddOrdonnanceSegue" {
            if let controller = sender.source as? AddOrdonnanceViewController{
                if let _ = controller.ordonnance{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    appDelegate.saveContext()
                    self.ordonnanceTable.reloadData()
                }
            }
        }
        print("I'm back")
    }


}
