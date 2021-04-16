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
    
    var direccion2 = ""
    
    var condicion2 = ""
    
    var ultimaRevision = ""
    
    var imagen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreCartel.text = name
        direccion.text = direccion2
        condicion.text = condicion2
        fechaUltRegistro.text = ultimaRevision
        detalles.text = detalles2
        
        
        if let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + imagen) {
                   DispatchQueue.global().async {
                       let data = try? Data(contentsOf: imageURL)
                       if let data = data {
                           let image = UIImage(data: data)
                           DispatchQueue.main.async {
                            self.img.image = image
                           }
                       }
                   }
               }
        
        
        
        

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func regresar(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
 

}
