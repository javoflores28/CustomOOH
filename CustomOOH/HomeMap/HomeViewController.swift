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



class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func didTapButton() {
    
    var image: UIImage? = nil
        
        
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
  
    private var carteles: [ParserCartelesJSON]! = []
    
    private var busquedaCarteles: [ParserCartelesJSON]! = []
    

    public var annotations = [AnnotationPlus]()
    
    //var ref: DatabaseReference!
    //ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 45

        //retrieveTheImage2()
 
        //Obtener Carteles JSON
        
        let url: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/paletas.json")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
   
        NSURLConnection.sendAsynchronousRequest(request, queue: .main)  { (response,carteles,error) in
            
            guard let carteles = carteles else {
                print(error!)
                return
            }
            
            let responseString:  String! = String(data: carteles, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.carteles = try jsonDecoder.decode([ParserCartelesJSON].self, from: carteles)
                self.busquedaCarteles  = self.carteles
               
                //print(self.carteles[0].nombre!)
            } catch {
                print(error)
            }
            
        }
        
        //print(carteles.count)
        // JSONDecoder().decode([AnnotationPlus].self, from: carteles)
        
        //MAPA
        
        mapView.delegate = self //Required
        
        var annotations: [AnnotationPlus] = []
        
        
        
        //annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: self.carteles[0].nombre, image: UIImage(named: "cafe.png")!), coordinate: CLLocationCoordinate2DMake(19.87, -99.97)))
        
        annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: "Cafe", image: UIImage(named: "cafe.png")!), coordinate: CLLocationCoordinate2DMake(19.395056366804322, -99.1747505026115)))
        
        annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: "Factory", image: UIImage(named: "factory")!), coordinate: CLLocationCoordinate2DMake(50.85, 4.35)))

        annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: "House", image: UIImage(named: "house")!), coordinate: CLLocationCoordinate2DMake(48.85, 2.35)))

        annotations.append(AnnotationPlus.init(viewModel: BasicCalloutViewModel.init(title: "Skyscraper", image: UIImage(named: "skyscraper")!), coordinate:CLLocationCoordinate2DMake(46.2039, 6.1400)))
        
        
        
        mapView.setup(withAnnotations: annotations)
        
        //self.mapView.anchorViewCustomizerDelegate = self
        
    
        //MENU
        
        menuView.layer.cornerRadius = 20
        //menuView.layer.shadowColor = UIColor.black.cgColor
        //menuView.layer.shadowOpacity = 10
        //menuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        sideView.layer.cornerRadius = 20
        //sideView.layer.shadowColor = UIColor.black.cgColor
        //sideView.layer.shadowOpacity = 10
        //sideView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        /*
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.nombreUsuario.text = username

        }
        */
        
       
        viewConstraint.constant = -270
        
        //Ponder foto de perfil
        
        //INTENTO CON COLLECTION DOCUMENTS FIRESTORE:
        

        
        
        
        
        /*
         
        //INTENTO 1:
         
        let userID = Auth.auth().currentUser?.uid
        let retrieveTheUrl = Database.database().reference().child("users").child(userID!)
        var capatureUrl :String = ""
        retrieveTheUrl.observeSingleEvent(of: .value) { (snapShot) in
            if let snapShotValue = snapShot.value as? Dictionary<String,String>{
                let url = snapShotValue["profileImageUrl"]!
                print(url)
                capatureUrl = url
                print(capatureUrl)
                
                Storage.storage().reference(forURL: capatureUrl).downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data )
                self.imageView.image = image
                
            }
            }
        }
        */

        //INTENTO 2:
        /*
        var imageURL = ""
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference().child("users").child(uid!)
        dbRef.observeSingleEvent(of: .value, with: { snapshot in
           if snapshot.exists() {
              guard let dict = snapshot.value as? [String: Any] else {
                 return
              }
            imageURL = dict["profileImageUrl"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/customooh.appspot.com/o/users%2F2vMGTbkwQHMg2GZXwps3RnW6IGF3?alt=media&token=77019882-a149-4cd5-97aa-650a11c1829f"
            print(imageURL)
            Storage.storage().reference(forURL: imageURL).downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data )
            self.imageView.image = image
            }
           }
        }){ (error) in
           print(error.localizedDescription)
        }
        
        */


        //PRUEBA CON URL HARDCODEADA
        
        /*
        let userID = Auth.auth().currentUser?.uid
        let retrieveTheUrl = Database.database().reference().child("users").child(userID!)
        var pruebaUrl = "https://firebasestorage.googleapis.com/v0/b/customooh.appspot.com/o/users%2F2vMGTbkwQHMg2GZXwps3RnW6IGF3?alt=media&token=77019882-a149-4cd5-97aa-650a11c1829f"
        let storage = Storage.storage()
        var reference: StorageReference!
        reference = storage.reference(forURL:  pruebaUrl) //will be valid here.
        reference.downloadURL { (url, error) in
            let data2 = NSData(contentsOf: url!)
            let image2 = UIImage(data: data2! as Data )
            self.imageView.image = image2
        }
        */
        
        //INTENTO 3:
        
        /*
        
        let ref = Database.database(url: "346118699485-arhh7acmg6h9o2atdg58fdtlt0509e97.apps.googleusercontent.com").reference()
        let uid = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(uid!)

        // only need to fetch once so use single event
        usersRef.observeSingleEvent(of: .value, with: { snapshot in

            if !snapshot.exists() { return }

            //print(snapshot)

            let userInfo = snapshot.value as! NSDictionary
            print(userInfo)
            print(userInfo["username"]!)
            let profileUrl = userInfo["profileImageUrl"] as! String

            print(profileUrl)
            Storage.storage().reference(forURL: profileUrl).downloadURL(completion: { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.imageView.image = image
            })
        })
        */
        
        getUrl{(url) in
            self.getImage(Url:url)
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
        return currentCalloutView?.backgroundColor ?? mapView.defaultFillColorForAnchors
    }
}

extension HomeViewController: BasicCalloutViewModelDelegate {
    func detailButtonTapped(withTitle title: String) {
        let alert = UIAlertController.init(title: "\(title) tapped", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




