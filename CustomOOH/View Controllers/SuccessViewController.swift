//
//  SuccessViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 06/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regresar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)

    }
    
    

}
