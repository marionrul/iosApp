//
//  DialogBoxHelper.swift
//  MyPeka
//
//  Created by Cyril PLUCHE on 13/03/2018.
//  Copyright © 2018 Polytech. All rights reserved.
//

import Foundation
import UIKit

class DialogBoxHelper {
    
    /// Affiche une alerte avec deux messages
    ///
    /// - Parameters:
    ///   - view : Vue où l'on veut afficher l'alerte
    ///   - title: Le titre de la boîte d'alerte
    ///   - msg: Message supplémentaire utilisé pour décrire le contexte ou une info supplémentaire
    static func alert(view: UIViewController, WithTitle title: String, andMessage msg: String = "") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(cancelAction)
        view.present(alert, animated: true)
    }
    

    /// Affiche une alerte pour informer qu'il y a une erreur
    ///
    /// - Parameters:
    ///   - view: Vue où l'on veut afficher l'alerte
    ///   - error: L'erreur dont on veut connaître l'information
    static func alert(view: UIViewController, error: NSError) {
        self.alert(view: view, WithTitle: "\(error)", andMessage: "\(error.userInfo)")
    }

    
}
