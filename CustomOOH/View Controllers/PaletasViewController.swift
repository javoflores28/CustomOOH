//
//  PaletasViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit


class PaletasViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var carteles: [ParserCartelesJSON]! = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    /*
    var cartelesArr =  [
        
        "Paleta 1",
        "Paleta 2",
        "Paleta 3",
        "Paleta 4",
        "Paleta 5",
        "Paleta 6",
        "Paleta 7",
        "Paleta 8",
        "Paleta 9",
        "Paleta 10"
    ]
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/carteles.json")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //if using POST
        /*
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let dataStr: String = "value=1&value=2"
        let postData: Data = dataStr.data(using: .utf8)
        request.httpBody = postData
        */
        
        NSURLConnection.sendAsynchronousRequest(request, queue: .main)  { (response,carteles,error) in
            
            guard let carteles = carteles else {
                print(error)
                return
            }
            
            let responseString:  String! = String(data: carteles, encoding: .utf8)
            print(responseString)
            
            do  {
                let  jsonDecoder: JSONDecoder = JSONDecoder()
                self.carteles = try jsonDecoder.decode([ParserCartelesJSON].self, from: carteles)
                self.collectionView.reloadData()
                
                //print(self.carteles[0].nombre!)
            } catch {
                print(error)
            }
            
        }
 
        
        collectionView.layer.cornerRadius = 4


        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          //return cartelesArr.count
            return carteles.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
          
        /*
          var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PaletasCollectionViewCell
        */
        
        let cell: PaletasCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaletasCollectionViewCell
        
        cell.nombreCartel.text = self.carteles[indexPath.item].nombre
        cell.detalles = self.carteles[indexPath.item].detalles
        
        
        /*
          cell?.img.image = UIImage(named: carteles[indexPath.row])
          cell?.nombreCartel.text = cartele[indexPath.row]
       
        return cell!
        */
        
        return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let vc = storyboard?.instantiateViewController(withIdentifier: "DetallesCartelViewController") as? DetallesCartelViewController
          
          //vc?.name = cartelesArr[indexPath.row]
          vc?.name = self.carteles[indexPath.item].nombre
          vc?.detalles2 = self.carteles[indexPath.item].detalles
          self.navigationController?.pushViewController(vc!, animated: true)
          
      }

}




/*
extension PaletasViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
    
    
}
*/
