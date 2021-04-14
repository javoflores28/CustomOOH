//
//  SplashViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 13/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    /*
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 307, height: 247))
        imageView.image = UIImage(named: "LogoSinTexto")
        return imageView
        
    }()
*/
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var texto: UIImageView!
    
    @IBOutlet weak var rango1: UIImageView!
    @IBOutlet weak var rango2: UIImageView!
    @IBOutlet weak var rango3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rango1.isHidden = true
        rango2.isHidden = true
        rango3.isHidden = true
        
        view.addSubview(imageView)
        
        //view.addSubview(imageView)
        //view.backgroundColor = .link

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //imageView.center = view.center
    
        //Aparecer rangos
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.rango1.isHidden = false
        })
             
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
            self.rango2.isHidden = false
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
            self.rango3.isHidden = false
        })
        
        //Desaparecer rangos
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
              self.rango3.isHidden = true
            
        })
               
        DispatchQueue.main.asyncAfter(deadline: .now()+1.3, execute: {
              self.rango2.isHidden = true
        })
          
        DispatchQueue.main.asyncAfter(deadline: .now()+1.6, execute: {
              self.rango1.isHidden = true
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
            self.deslizarTexto()
      
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3.8, execute: {
            self.animate()
        })
        
        
    }
    
    private func deslizarTexto() {
              
        UIView.animate(withDuration: 1.5, animations: {
        
            self.texto.frame = CGRect(
                x: 25,
                y: 458,
                width: 325,
                height: 189
            )
            //self.imageView.alpha = 0
        })
        
    }
    
 
    private func animate() {
        
        UIView.animate(withDuration: 1.7, animations: {
            
            let size = self.view.frame.size.width * 2.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            //self.imageView.alpha = 0
        })
        
        UIView.animate(withDuration: 1, animations: {
            
            self.texto.alpha = 0
        }, completion: { done in
            if done {
                //let viewController = ViewController()
                
                //viewController.modalTransitionStyle = .crossDissolve
                //viewController.modalPresentationStyle = .fullScreen
                //self.present(viewController
                //, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5
                    , execute: {
                        let mainViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewContorller) as? ViewController
                                               
                        mainViewController?.modalTransitionStyle = .crossDissolve
                        
                        mainViewController?.modalPresentationStyle = .fullScreen
                        
                            self.view.window?.rootViewController = mainViewController
                            self.view.window?.makeKeyAndVisible()
                                 
                })
         
            }
            
        }
        
        
        )
        
    }
    



}
