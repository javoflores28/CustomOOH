//
//  LlenarFormularioViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class LlenarFormularioViewController: UIViewController {
    
    public var completionHnadler1: ((String?) -> Void)?
    
    public var completionHnadler2: ((String?) -> Void)?
    
    public var completionHnadler3: ((String?) -> Void)?
    
    public var completionHnadler4: ((String?) -> Void)?
    
    public var completionHnadler5: ((Bool?) -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registrarFromulario(_ sender: Any) {
        completionHnadler1?("Paso2_Listo")
        completionHnadler2?("formularioListo")
        completionHnadler3?("Paso3_Listo")
        completionHnadler4?("registrarBoton")
        completionHnadler5?(false)
        
        dismiss(animated: true, completion: nil)
    }
    

}
