//
//  HomeViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 05/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {



    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIImageView!
    
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var nombreUsuario: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.cornerRadius = 20
        //menuView.layer.shadowColor = UIColor.black.cgColor
        //menuView.layer.shadowOpacity = 10
        //menuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        sideView.layer.cornerRadius = 20
        //sideView.layer.shadowColor = UIColor.black.cgColor
        //sideView.layer.shadowOpacity = 10
        //sideView.layer.shadowOffset = CGSize(width: 5, height: 5)
        if Auth.auth().currentUser != nil {
            if let name = Auth.auth().currentUser?.email {
            nombreUsuario.text = "Hola 🤗\n" + name
            }
        }
        
        viewConstraint.constant = -270
       
       
    }
    
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
                      
               self.view.window?.rootViewController = mainViewController
               self.view.window?.makeKeyAndVisible()
                      
               
           } catch let signOutError as NSError {
             print ("Error signing out: %@", signOutError)
           }
    }
    

 

}
