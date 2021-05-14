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
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var fondoFoto: UIImageView!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        fondoFoto.layer.cornerRadius = 50
        
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        setupAvatar()

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
            //var imageUrl = imageUrlTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            var imageUrl = ""
            
           
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Check for errors
                if err != nil {
                    //There was an error when creating the user
                    self.showError("Error al crear el usuario")
                } else {
                    
                    //User was created successfuclly, now store the username
                    let db = Firestore.firestore()
                    
                    let storageRef = Storage.storage().reference(forURL: "gs://customooh.appspot.com")
                    
                    let storageProfileRef = storageRef.child("users").child(result!.user.uid)
                    
                    
                    guard let imageSelected = self.image else {
                        print("Avatar is nil")
                        return
                    }
                    
                    guard let imageData  = imageSelected.jpegData(compressionQuality: 0.4) else {
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
                                    
                                    db.collection("users").document(result!.user.uid).setData(["username": username,"email":email, "profileImageUrl":imageUrl, "uid":result!.user.uid]) { (error) in
                                            if error != nil {
                                            //Show error message
                                                self.showError("User data couldn't be saved")
                                    
                                            }
                                       
                                    }
                                }
                                
                            })
                            
                    })
                    
                    //aqui iba antes

                        
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
    
    
    @IBAction func regresar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)

    }
    
    
    
}


extension SignUpViewController {
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 45
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing  = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}



extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  {
            image = imageSelected
            avatar.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
