//
//  ViewController.swift
//  MyPeka
//
//  Created by Polytech on 12/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var activitePresenter: ActivitePresenter!
    
    /// TableView controlée par "self" qui affiche la collection d'"ActiviteSportive"
    @IBOutlet weak var activiteTable: UITableView!
    
    /// On utilise NSFetchedResultsController pour connecter le Core Data aux vues (storyboards)
    fileprivate lazy var activitesFetched : NSFetchedResultsController<ActiviteSportive> = {
        // prepare une requête
        let request : NSFetchRequest<ActiviteSportive> = ActiviteSportive.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(ActiviteSportive.date), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
           try self.activitesFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ActiviteSportive data management
    
    
    /// Supprime l'activité dont l'index est passé en paramètre
    /// Precondition: Index must be in bound of collection
    /// - Parameter activiteWithIndex: Index de l'activité à supprimer
    /// - Returns: True si l'activité a été supprimée
    func delete(activiteWithIndex index: IndexPath) -> Bool {
        let context = CoreDataManager.context
        let activite = self.activitesFetched.object(at: index)
        context.delete(activite)
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
        self.activiteTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.activiteTable.endUpdates()
        CoreDataManager.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                self.activiteTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.activiteTable.insertRows(at: [newIndexPath], with: .fade)
            }
            
        default:
            break
        }
    }

    // MARK: - TableView data source protocole
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.activiteTable.dequeueReusableCell(withIdentifier: "activiteCell", for: indexPath) as! ActiviteTableViewCell
        let activite = self.activitesFetched.object(at: indexPath)
        self.activitePresenter.configure(theCell: cell, forActivite: activite)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return self.activites.count
        guard let section = self.activitesFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //Pour gérer la suppression
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.activiteTable.beginUpdates()
            if self.delete(activiteWithIndex: indexPath){
                self.activiteTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.activiteTable.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // MARK: - Navigation
    
    let segueShowActiviteId = "showActiviteSegue"
    
    /// Dans une application story-board-based, on voudra souvent préparer une petite navigation
    /// Ici on prépare la navigation vers la vue show activité
    ///
    /// - Parameters:
    ///   - segue: Provoque la transition
    ///   - sender: Vue qui envoie cette transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueShowActiviteId {
            if let indexPath = self.activiteTable.indexPathForSelectedRow {
                let showActiviteViewController = segue.destination as! ShowActiviteViewController
                showActiviteViewController.activite = self.activitesFetched.object(at: indexPath)
                self.activiteTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    /// Indique la destination où on veut retourner
    /// - Parameters:
    ///   - sender : Le segue où on se trouvait
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        if sender.identifier == "OkAddActivitySegue" {
            if let controller = sender.source as? AddActivityViewController{
                if let activite = controller.activite{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                        return
                    }
                    appDelegate.saveContext()
                    self.activiteTable.reloadData()
                    ActivityNotificationCenter.programmedAllNotificationActivity(nameActivity: activite.nom, libelleActivity: activite.description!, forDate: activite.date as Date)
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

