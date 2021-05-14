//
//  HomeViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 05/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import MapViewPlus
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore
import Firebase
import SwiftUI
import MapKit



class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    let imagenAzul: UIImage = UIImage(named: "azul")!

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func didTapButton() {
    
    //var image: UIImage? = nil
        
        
        //ImagePicker
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let db = Firestore.firestore()
        let storage = Storage.storage().reference(forURL: "gs://customooh.appspot.com")
        let userID = Auth.auth().currentUser?.uid
        let storageProfileRef = storage.child("users").child(userID!)
        var imageUrl = ""
        
        let user = Auth.auth().currentUser
        
        
    
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion:
            { (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if var metaImageUrl = url?.absoluteString {
                        print(metaImageUrl)
                        imageUrl =  metaImageUrl
                        
                        DispatchQueue.global().async {

                                       let url = URL(string: imageUrl)
                                       if let data = try? Data(contentsOf: url!) {

                                           DispatchQueue.main.async {

                                                self.imageView.image = UIImage(data: data)
                                               }
                                           }
                                       }
                        
                        Firestore.firestore().collection("users").document(userID!).getDocument { (docSnapshot, error) in
                                   if error != nil {
                                       return
                                   } else {
                                       guard let snapshot = docSnapshot, snapshot.exists else {return}
                                       guard let data = snapshot.data() else {return}
                                       
                                       let username = data["username"] as! String
                                
                                    
                                    db.collection("users").document(userID!).setData(["username": username,"email": Auth.auth().currentUser?.email, "profileImageUrl":imageUrl, "uid":Auth.auth().currentUser?.uid])  { (error) in
                                            if error != nil {
                                            //Show error message
                                                print("User data couldn't be saved")
                                    
                                            }
                                       
                                        }
                                   }
                               }

                    }
                    
                })
                
        })
        

        // upload image data
        // get download url
        // save download url to user Defaults
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    
    @IBOutlet weak var mapView: MapViewPlus!
    
    weak var currentCalloutView: UIView?
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIImageView!
    
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var nombreUsuario: UILabel!

    let url1: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/paletas.json")!
    let url2: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/medianos.json")!
    let url3: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/urbanos.json")!
    let url4: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/grandes.json")!
    
    
    private var listaPaletas: [ParserCartelesJSON]! = []
    private var listaMedianos: [ParserCartelesJSON]! = []
    private var listaUrbanos: [ParserCartelesJSON]! = []
    private var listaGrandes: [ParserCartelesJSON]! = []
    //private var busquedaCarteles: [ParserCartelesJSON]! = []
    
    

    public var annotations = [AnnotationPlus]()
    
    public var medianos = [AnnotationPlus]()
    
    public var urbanos = [AnnotationPlus]()
    
    public var grandes = [AnnotationPlus]()
    
    //var ref: DatabaseReference!
    //ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 45
        
        mapView.delegate = self //Required
        
        mapView.showsUserLocation = true
        
        //MENU
        
        menuView.layer.cornerRadius = 20
        //menuView.layer.shadowColor = UIColor.black.cgColor
        //menuView.layer.shadowOpacity = 10
        //menuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        sideView.layer.cornerRadius = 20
        //sideView.layer.shadowColor = UIColor.black.cgColor
        //sideView.layer.shadowOpacity = 10
        //sideView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
       
        viewConstraint.constant = -270
        
        getUrl{(url) in
            self.getImage(Url:url)
        }
    
    }
    
    
    @IBAction func botonPaletas(_ sender: Any) {
        mapView.delegate = self
        
        self.mapView.removeAllAnnotations()
        
        var request1: URLRequest = URLRequest(url: url1)
        request1.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: .main)  { (response,listaPaletas,error) in
            
            guard let listaPaletas = listaPaletas else {
                print(error!)
                return
            }
            
            let responseString:  String! = String(data: listaPaletas, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.listaPaletas = try jsonDecoder.decode([ParserCartelesJSON].self, from: listaPaletas)
                //self.busquedaCarteles  = self.carteles
                print("esoty adentro")
                
                var annotations: [AnnotationPlus] = []
                print(self.listaPaletas.count)
                
                for i in 0...self.listaPaletas.count-1{
                    //print(i)
                    let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + self.listaPaletas[i].media[0].url)
                    let data = try? Data(contentsOf: imageURL!)
                    let image = UIImage(data: data!)
                    
                    annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: self.listaPaletas[i].nombre, image: image!, direccion: self.listaPaletas[i].direccion ), coordinate: CLLocationCoordinate2DMake(self.listaPaletas[i].coordenadasX, self.listaPaletas[i].coordenadasY)))
                }
            
                
                self.mapView.setup(withAnnotations: annotations)
                self.mapView.anchorViewCustomizerDelegate = self
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    @IBAction func botonMedianos(_ sender: Any) {
        
        mapView.delegate = self
        
        self.mapView.removeAllAnnotations()
        
        var request2: URLRequest = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request2, queue: .main)  { (response,listaMedianos,error) in
            
            guard let listaMedianos = listaMedianos else {
                print(error!)
                return
            }
            
            let responseString:  String! = String(data: listaMedianos, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.listaMedianos = try jsonDecoder.decode([ParserCartelesJSON].self, from: listaMedianos)
                print("esoty adentro")
                print(self.listaMedianos[0].coordenadasX)
                
                var medianos: [AnnotationPlus] = []
                print(self.listaMedianos.count)
                
                for i in 0...self.listaMedianos.count-1{
                    //print(i)
                    let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + self.listaMedianos[i].media[0].url)
                    
                    let data = try? Data(contentsOf: imageURL!)
                    let image = UIImage(data: data!)
                    medianos.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: self.listaMedianos[i].nombre, image: image!, direccion: self.listaMedianos[i].direccion), coordinate: CLLocationCoordinate2DMake(self.listaMedianos[i].coordenadasX, self.listaMedianos[i].coordenadasY)))
                }

            
                self.mapView.setup(withAnnotations: medianos)
                self.mapView.anchorViewCustomizerDelegate = self
                
            
            } catch {
                print(error)
            }
            
        }
        
    }
    
    @IBAction func botonMobilario(_ sender: Any) {
        
        mapView.delegate = self
        
        self.mapView.removeAllAnnotations()

        var request3: URLRequest = URLRequest(url: url3)
        request3.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request3, queue: .main)  { (response,listaUrbanos,error) in
            
            guard let listaUrbanos = listaUrbanos else {
                print(error!)
                return
            }
            
            let responseString:  String! = String(data: listaUrbanos, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.listaUrbanos = try jsonDecoder.decode([ParserCartelesJSON].self, from: listaUrbanos)
                print("esoty adentro")
                print(self.listaUrbanos[0].coordenadasX)
                
                var urbanos: [AnnotationPlus] = []
                print(self.listaUrbanos.count)
                
                for i in 0...self.listaUrbanos.count-1{
                    //print(i)
                    let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + self.listaUrbanos[i].media[0].url)
                    
                    let data = try? Data(contentsOf: imageURL!)
                    let image = UIImage(data: data!)
                    urbanos.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: self.listaUrbanos[i].nombre, image: image!, direccion: self.listaUrbanos[i].direccion), coordinate: CLLocationCoordinate2DMake(self.listaUrbanos[i].coordenadasX, self.listaUrbanos[i].coordenadasY)))
                }

            
                self.mapView.setup(withAnnotations: urbanos)
                self.mapView.anchorViewCustomizerDelegate = self
                
            
            } catch {
                print(error)
            }
            
        }
        
        
    }
    
    @IBAction func botonGrandes(_ sender: Any) {
        
        mapView.delegate = self
        
        self.mapView.removeAllAnnotations()

        var request4: URLRequest = URLRequest(url: url3)
        request4.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request4, queue: .main)  { (response,listaGrandes,error) in
            
            guard let listaGrandes = listaGrandes else {
                print(error!)
                return
            }
            
            let responseString:  String! = String(data: listaGrandes, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.listaGrandes = try jsonDecoder.decode([ParserCartelesJSON].self, from: listaGrandes)
                
                var grandes: [AnnotationPlus] = []
                
                for i in 0...self.listaGrandes.count-1{
                    //print(i)
                    let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + self.listaGrandes[i].media[0].url)
                    
                    let data = try? Data(contentsOf: imageURL!)
                    let image = UIImage(data: data!)
                    grandes.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: self.listaGrandes[i].nombre, image: image!, direccion: self.listaGrandes[i].direccion), coordinate: CLLocationCoordinate2DMake(self.listaGrandes[i].coordenadasX, self.listaGrandes[i].coordenadasY)))
                }

            
                self.mapView.setup(withAnnotations: grandes)
                self.mapView.anchorViewCustomizerDelegate = self
                
            
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    
    
    //Function to get photo of loggedin User
    func getUrl(Completion:@escaping((String)->())) {

        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore().collection("users").document(userID!)
        print(db)
        db.getDocument { (docSnapshot, error) in
            if error != nil {
                return
            } else {
                guard let snapshot = docSnapshot, snapshot.exists else {return}
                guard let data = snapshot.data() else {return}
                let imageUrl = data["profileImageUrl"] as! String
                Completion(imageUrl)
                
                DispatchQueue.global().async {

                let url = URL(string: imageUrl)
                if let data = try? Data(contentsOf: url!) {

                    DispatchQueue.main.async {

                         self.imageView.image = UIImage(data: data)
                        }
                    }
                }
                
                let username = data["username"] as! String
                self.nombreUsuario.text = "¡Hola " + username + "! 🤗\n"
            }
        }
 
    }
    
    //Call this function in VC where your `ImageView` is
    func getImage(Url:String){

         DispatchQueue.global().async {

             let url = URL(string: Url)
             if let data = try? Data(contentsOf: url!) {

                DispatchQueue.main.async {

                      self.imageView.image = UIImage(data: data)

                        }
                }
         }
    }
    
    //CAMBIAR IMAGEN
    
    
    
    
    
    
    
    
    
    

    //Desplazar para mostrar y ocultar Menú

    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        
        if sender.state  == .began || sender.state == .changed {
            
            let translation = sender.translation(in: self.view).x
            if translation > 0 { //swipe right
                
                if viewConstraint.constant < 5 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        
                    })
                }
                
            } else { //swipe left
                if viewConstraint.constant > -270 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                                       
                    })
                }
                
            }
            
        } else if sender.state == .ended { //ocultar menu
            if viewConstraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewConstraint.constant = -270
                    self.view.layoutIfNeeded()
                                   
                })
            }  else {
                
                UIView.animate(withDuration: 0.2, animations: {
                self.viewConstraint.constant = 0
                self.view.layoutIfNeeded()
                    
                })
            }
            
            
        }
    }
    
    //Botón para mostrar Menú
    @IBAction func showMnu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.viewConstraint.constant = 0
            self.view.layoutIfNeeded()
          })
    }
    

    //Botón para ocultar Menú
    @IBAction func closeMenu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewConstraint.constant = -270
            self.view.layoutIfNeeded()
                           
        })
        
    }
    


    //signOut
    @IBAction func salir(_ sender: Any) {
        do {
               try Auth.auth().signOut()
             let mainViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewContorller) as? ViewController
            
            mainViewController?.modalTransitionStyle = .flipHorizontal
                      
               self.view.window?.rootViewController = mainViewController
            
               self.view.window?.makeKeyAndVisible()
            
            //present(mainViewController!, animated: true)
                      
               
           } catch let signOutError as NSError {
             print ("Error signing out: %@", signOutError)
           }
    }
}

//Extensiones de MapViewPlus

extension HomeViewController: MapViewPlusDelegate {
    
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, calloutViewFor medianosView: AnnotationViewPlus) -> CalloutViewPlus {
         let calloutView = Bundle.main.loadNibNamed("BasicCalloutView", owner: nil, options: nil)!.first as! BasicCalloutView
               calloutView.delegate = self
               currentCalloutView = calloutView
               return calloutView
    }
    
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, imageFor medianos: AnnotationPlus) -> UIImage {
        return UIImage(named: "azul")!
    }
    
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        
        return UIImage(named: "basic_annotation_image")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus{
        let calloutView = Bundle.main.loadNibNamed("BasicCalloutView", owner: nil, options: nil)!.first as! BasicCalloutView
        calloutView.delegate = self
        currentCalloutView = calloutView
        return calloutView
    }
    
    // Optional
    func mapView(_ mapView: MapViewPlus, didAddAnnotations annotations: [AnnotationPlus]) {
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension HomeViewController: AnchorViewCustomizerDelegate {
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor {
        return currentCalloutView?.backgroundColor ?? UIColor.init(patternImage: imagenAzul)
    }
}

extension HomeViewController: BasicCalloutViewModelDelegate {
    func detailButtonTapped(withTitle title: String, image: UIImage, direccion: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetallesCartel2ViewController") as? DetallesCartel2ViewController
        
        vc?.name = title
        vc?.detalles2 = "Medidas de 4x5 aprox, único dueño"
        vc?.direccion2 = direccion
        vc?.condicion2 = "Condición: " + listaPaletas[0].condicion
        vc?.ultimaRevision = "Última revisión: 24/04/2021"
        //vc?.regresar2.isHidden = false

        vc?.imagen = image
   
        vc?.modalTransitionStyle = .flipHorizontal
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()

        //Si funciona -> self.present(vc!, animated:true, completion:nil)
        //navigationController?.pushViewController(vc!, animated: true)
             
        
        //Alerta popo up normal
        /*
        let alert = UIAlertController.init(title: "\(title) tapped", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
         */
    }
}




