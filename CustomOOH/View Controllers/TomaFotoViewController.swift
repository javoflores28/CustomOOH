//
//  TomaFotoViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class TomaFotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tomaFoto(_ sender: Any) {
    
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    


}
