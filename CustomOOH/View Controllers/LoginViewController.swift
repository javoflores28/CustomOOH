//
//  LoginViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 05/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
          
          //Hide error label
          errorLabel.alpha = 0
          
          //Style the elements
          Utilities.styleTextField(emailTextField)
          
          Utilities.styleTextField(passwordTextField)
          
          //Utilities.styleFilledButton(loginButton)
      
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate the fields
        
        //Create clean version of the trext field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = passwordTextField!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                //Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                
                homeViewController?.modalTransitionStyle = .flipHorizontal
              
                       
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
                //self.present(homeViewController!, animated: true)
                
                
                       
                
            }
        }
   
    }
    
    
    @IBAction func regresar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)

    }
    
    
    
    
    
    //signOut
    /*
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
    */
    
}
