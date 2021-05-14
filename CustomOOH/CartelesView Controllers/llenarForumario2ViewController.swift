//
//  llenarForumario2ViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 13/05/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class llenarForumario2ViewController: UIViewController {
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
