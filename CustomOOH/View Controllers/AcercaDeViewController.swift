//
//  AcercaDeViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class AcercaDeViewController: UIViewController {


    
    @IBOutlet weak var santi: UIImageView!
    
    
    @IBOutlet weak var javi: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        javi.isHidden = true
        santi.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //imageView.center = view.center
    
        //Aparecer rangos
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.santi.isHidden = false
            self.javi.isHidden = false
            self.deslizarTexto()
        })
        
    }
    private func deslizarTexto() {
                
          UIView.animate(withDuration: 2, animations: {
          
              self.javi.frame = CGRect(
                  x: 217,
                  y: 266,
                  width: 159,
                  height: 163
              )
            
              self.santi.frame = CGRect(
                  x: 6,
                  y: 271,
                  width: 150,
                  height: 163
              )
              //self.imageView.alpha = 0
          })
          
      }
    
    
    
    
    
    
    

    @IBAction func regresar(_ sender: Any) {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                                    
                   //self.view.window?.rootViewController = homeViewController
                   //self.view.window?.makeKeyAndVisible()
               
                   self.present(homeViewController!, animated: false, completion: {
                       homeViewController?.viewConstraint.constant = 0
                       homeViewController?.view.layoutIfNeeded()
               
                   })
           
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
