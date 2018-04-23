//
//  RdvViewController.swift
//  MyPeka
//
//  Created by Polytech on 26/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class RdvViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, NSFetchedResultsControllerDelegate {

    /// TableView controlée par "self" qui affiche la collection de "Rendez-vous"
    @IBOutlet weak var rdvTable: UITableView!
    
    @IBOutlet var rdvPresenter: RdvPresenter!
    
    fileprivate lazy var rdvFetched : NSFetchedResultsController<RendezVous> = {
        // prepare une requête
        let request : NSFetchRequest<RendezVous> = RendezVous.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(RendezVous.date), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try self.rdvFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Rendez-vous data management
    
    
    /// Supprime le rendez vous dont l'index est passé en paramètre
    /// Precondition: Index must be in bound of collection
    /// - Parameter  rendezVousWithIndex: Index du rendez vous à supprimer
    /// - Returns: True si le rendez vous a été supprimé
    func delete(rdvWithIndex index: IndexPath) -> Bool {
        let context = CoreDataManager.context
        let rdv = self.rdvFetched.object(at: index)
        context.delete(rdv)
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
        self.rdvTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rdvTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.rdvTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.rdvTable.insertRows(at: [newIndexPath], with: .fade)
            }
            
        default:
            break
        }
    }
    
    func save() {
        if let error = CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    
    // MARK: - TableView data source protocole
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.rdvTable.dequeueReusableCell(withIdentifier: "rdvCell", for: indexPath) as! RdvTableViewCell
        let rdv = self.rdvFetched.object(at: indexPath)
        self.rdvPresenter.configure(theCell: cell, forRdv: rdv)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.rdvFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //Pour gérer la suppression
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.rdvTable.beginUpdates()
            if self.delete(rdvWithIndex: indexPath){
                self.rdvTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.rdvTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    

    // MARK: - Navigation
    
    let segueShowRdvId = "showRdvSegue"
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show activité
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowRdvId {
            if let indexPath = self.rdvTable.indexPathForSelectedRow {
                let showRdvViewController = segue.destination as! ShowRdvViewController
                showRdvViewController.rdv = self.rdvFetched.object(at: indexPath)
                self.rdvTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    /// Indique la destination où on veut retourner
    /// - Parameters:
    ///   - sender : Le segue où on se trouvait
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if sender.identifier == "OkAddRdvSegue" {
            if let controller = sender.source as? AddRdvViewController{
                if let rdv = controller.rdv{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    appDelegate.saveContext()
                    self.rdvTable.reloadData()
                     RdvNotificationCenter.programmedAllNotificationRdv(nameRdv: rdv.libelle, docteurRdv: (rdv.docteur?.nom)!, forDate: rdv.date as Date)
                }
            }
        }
        print("I'm back")
    }

    // MARK: - Helper methods
    
    
    /// Retourne le contexte d'un core data initialisé dans l'application delegate
    ///
    /// - Parameters:
    ///   - errorMsg: le principal message d'erreur
    ///   - userInfoMsg: information supplémentaire que l'on veut afficher
    /// - Returns: le contexte du CoreData
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        // Retourne le contexte d'une donnée persistante
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            DialogBoxHelper.alert(view: self, WithTitle: errorMsg, andMessage: userInfoMsg)
            //self.alert(WithTitle: errorMsg, andMessage: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }


}
