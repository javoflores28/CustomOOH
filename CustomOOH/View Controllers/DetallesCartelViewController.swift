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
    
    @IBOutlet weak var registrar: UIImageView!
    
    @IBOutlet weak var foto: UIButton!
    
    @IBOutlet weak var formulario: UIButton!
    
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
        
        formulario.isHidden = true
        
        
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
        
        //Haz los cambios pertientes en los campos para validar que se tomo la foto
        tomarFotoViewController?.completionHnadler1 = { text in
            self.paso_1.image = UIImage(named: text!)
        }
        tomarFotoViewController?.completionHnadler2 = { text in
            self.fotoTomada.image = UIImage(named: text!)
        }
        tomarFotoViewController?.completionHnadler3 = { text in
            self.instrucciones.image = UIImage(named: text!)
        }
        tomarFotoViewController?.completionHnadler4 = { Bool in
            self.foto.isHidden = Bool!
        }
        
        tomarFotoViewController?.completionHnadler5 = { Bool in
            self.formulario.isHidden = Bool!
        }
 
        present(tomarFotoViewController!, animated: true)
        
        //self.view.window?.rootViewController = tomarFotoViewController
        //self.view.window?.makeKeyAndVisible()
     
    }
    
    
    @IBAction func llenarFormulario(_ sender: Any) {
        
        let llenarForumariViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.llenarForumariViewController) as? LlenarFormularioViewController
        
        llenarForumariViewController?.modalPresentationStyle = .overCurrentContext
        llenarForumariViewController?.view.backgroundColor = .clear
        //llenarForumariViewController?.modalTransitionStyle = .flipHorizontal
        
        //Haz los cambios pertientes en los campos para validar que se llenó el formulario
        
        llenarForumariViewController?.completionHnadler1 = { text in
            self.paso_2.image = UIImage(named: text!)
        }
        llenarForumariViewController?.completionHnadler2 = { text in
            self.instrucciones.image = UIImage(named: text!)
        }
        llenarForumariViewController?.completionHnadler3 = { text in
            self.paso_3.image = UIImage(named: text!)
        }
        llenarForumariViewController?.completionHnadler4 = { text in
            self.registrar.image = UIImage(named: text!)
        }
        present(llenarForumariViewController!, animated: true)
        
    }
    
    
    
    
    

    
    @IBAction func regresar(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
 

}
