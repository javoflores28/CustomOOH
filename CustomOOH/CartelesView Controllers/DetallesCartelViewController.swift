//
//  DetallesCartelViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit
import CoreML
import Vision
@available(iOS 11.0, *)

class DetallesCartelViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    //Botones dinámicos que cambian 
    
    @IBOutlet weak var foto: UIButton!
    
    @IBOutlet weak var formulario: UIButton!
    
    @IBOutlet weak var registrarEvaluacion: UIButton!
    
    @IBOutlet weak var tomarfoto: UIButton!
    
    private let miPicker = UIImagePickerController()
    
    @IBOutlet weak var condicionImagen: UILabel!
    
    @IBOutlet weak var regresar1: UIButton!
    
    @IBOutlet weak var analizarFoto: UIButton!
    
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
        
        miPicker.delegate = self
        
        
        //Paso1.text = "Falta"
        
        nombreCartel.text = name
        direccion.text = direccion2
        condicion.text = condicion2
        fechaUltRegistro.text = ultimaRevision
        detalles.text = detalles2
        
        formulario.isHidden = true
        registrarEvaluacion.isHidden = true
        analizarFoto.isHidden = true

        
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
        
        llenarForumariViewController?.completionHnadler5 = { Bool in
             self.registrarEvaluacion.isHidden = Bool!
        }
        
        present(llenarForumariViewController!, animated: true)
        
    }
    

    
    
    @IBAction func ejecutarML() {
        //instanciar el modelo de la red neuronal
        let modelFile = MLcarteles2()
        let model = try! VNCoreMLModel(for: modelFile.model)
        //Convertir la imagen obtenida a CIImage
        let imagenCI = CIImage(image: fotoTomada.image!)
        //Crear un controlador para el manejo de la imagen, este es un requerimiento para ejecutar la solicitud del modelo
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        //Crear una solicitud al modelo para el análisis de la imagen
        let request = VNCoreMLRequest(model: model, completionHandler: resultadosModelo)
        try! handler.perform([request])

    }
    
    func resultadosModelo(request: VNRequest, error: Error?)
    {
        guard let results = request.results as? [VNClassificationObservation] else { fatalError("No hubo respuesta del modelo ML")}
        var bestPrediction = ""
        var bestConfidence: VNConfidence = 0
        //recorrer todas las respuestas en búsqueda del mejor resultado
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
        let resultado = "Estado: " + bestPrediction
        print(resultado)
        condicionImagen.text = resultado
    }
    
    
    @IBAction func album() {
        miPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        fotoTomada.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        paso_1.image = UIImage(named: "Paso1_Listo")
        //fotoTomada.image = UIImage(named: "fotoTomada")
        instrucciones.image = UIImage(named: "LlenaFormulario")
        tomarfoto.isHidden = true
        formulario.isHidden = false
        analizarFoto.isHidden = false
    
 
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func regresar(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func registrar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }


}
