//
//  TomaFotoViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class TomaFotoViewController: UIViewController {
    
    public var completionHnadler1: ((String?) -> Void)?
    
    public var completionHnadler2: ((String?) -> Void)?
    
    public var completionHnadler3: ((String?) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tomaFoto(_ sender: Any) {
        
        
        completionHnadler1?("Paso1_Listo")
        
        completionHnadler2?("fotoTomada")
        
        completionHnadler3?("LlenaFormulario")
        

        dismiss(animated: true, completion: nil)
        
        //_ = navigationController?.popViewController(animated: true)
        
    }
    


}
