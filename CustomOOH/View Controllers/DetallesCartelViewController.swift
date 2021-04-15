//
//  DetallesCartelViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class DetallesCartelViewController: UIViewController {

    @IBOutlet weak var nombreCartel: UILabel!
    
    @IBOutlet weak var direccion: UILabel!
    
    @IBOutlet weak var condicion: UILabel!
    
    @IBOutlet weak var fechaUltRegistro: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var detalles: UILabel!
    
    
    var name = ""
    
    var detalles2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreCartel.text = name
        img.image = UIImage(named: name)
        detalles.text = detalles2

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func regresar(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
 

}
