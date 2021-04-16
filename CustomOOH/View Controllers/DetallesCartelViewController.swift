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
    
    //Imagenes para cambiar de Paso
    @IBOutlet weak var instrucciones: UIImageView!
    
    @IBOutlet weak var paso_1: UIImageView!
    
    @IBOutlet weak var paso_2: UIImageView!
    
    @IBOutlet weak var paso_3: UIImageView!
    
    @IBOutlet weak var fotoTomada: UIImageView!
    
    //Varaibles para pasar los datos extraidos y recuperados del JSON
    var paso2 = "Falta"
    
    var paso3 = "Falta"
    
    var name = ""
    
    var detalles2 = ""
    
    var direccion2 = ""
    
    var condicion2 = ""
    
    var ultimaRevision = ""
    
    var imagen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Paso1.text = "Falta"
        
        nombreCartel.text = name
        direccion.text = direccion2
        condicion.text = condicion2
        fechaUltRegistro.text = ultimaRevision
        detalles.text = detalles2
        
        /*
        if  Paso1.text == "Listo" {
            paso_1.image = UIImage(named: "Paso1_Listo")
            instrucciones.image = UIImage(named: "")
            
        } else {
            paso_1.image = UIImage(named: "Paso1_Vacio")
            instrucciones.image = UIImage(named: "Click_Camara")
        }
        

        */
        
        
        
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
        
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
     
    @IBAction func tomarFoto(_ sender: Any) {
        
        let tomarFotoViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tomarFotoViewController) as? TomaFotoViewController
                    
        tomarFotoViewController?.modalPresentationStyle = .fullScreen
        tomarFotoViewController?.completionHnadler1 = { text in
            self.paso_1.image = UIImage(named: text!)
        }
        tomarFotoViewController?.completionHnadler2 = { text in
            self.fotoTomada.image = UIImage(named: text!)
        }
        tomarFotoViewController?.completionHnadler3 = { text in
            self.instrucciones.image = UIImage(named: text!)
        }
        present(tomarFotoViewController!, animated: true)
        
        //self.view.window?.rootViewController = tomarFotoViewController
        //self.view.window?.makeKeyAndVisible()
     
    }
    
    

    
    @IBAction func regresar(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
 

}
