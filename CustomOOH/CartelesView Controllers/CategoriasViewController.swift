//
//  CategoriasViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 11/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class CategoriasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Botón para regresar al menú del controlador del HomeViewController
    @IBAction func regresarMenu(_ sender: Any) {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                             
            //self.view.window?.rootViewController = homeViewController
            //self.view.window?.makeKeyAndVisible()
        
            self.present(homeViewController!, animated: false, completion: {
                homeViewController?.viewConstraint.constant = 0
                homeViewController?.view.layoutIfNeeded()
        
            })
    
    }

}
