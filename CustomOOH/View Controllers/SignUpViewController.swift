//
//  SignUpViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 05/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
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
        Utilities.styleTextField(usernameTextField)
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        //Utilities.styleFilledButton(signUpButton)
    
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Por favor llena todos los campos"
            
        }
        
        //Check if the password is secure
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword)  == false {
            //Password isn't secure enough
            return "La contraseña debe contener por lo menos 8 caracteres,  1 caracter especial y 1 numero."
        }
           
        
        return nil
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
         
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            //Theres something wrong with the fields, shwo error message
            showError(error!)

        } else {
            
            //Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
           
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors
                if err != nil {
                    //There was an error when creating the user
                    self.showError("Error al crear el usuario")
                } else {
                    
                    //User was created successfuclly, now store the username
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username": username,"email":email, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            //Show error message
                            self.showError("User data couldn't be saved")

                        }
                        
                    }
                    
                    //Transition to next screen
                    self.transitionToHome()
             
                }
                
           
                
            }
                
            
        }
        
          
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let successViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.successViewController) as? SuccessViewController
        
        view.window?.rootViewController = successViewController
        view.window?.makeKeyAndVisible()
        
        

    }
    
}
