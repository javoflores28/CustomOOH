//
//  MedianosViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class MedianosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    private var carteles: [ParserCartelesJSON]! = []
       
    private var busquedaCarteles: [ParserCartelesJSON]! = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/medianos.json")!
        var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
               
               
               
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
                self.busquedaCarteles  = self.carteles
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
           
           let cell: MedianosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMedianos", for: indexPath) as! MedianosCollectionViewCell
           
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
       
      func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
       let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchBarMedianos", for: indexPath)
           return searchView
       }
       

       /*
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           self.carteles.removeAll()
                            
                       for item in self.busquedaCarteles {
                           if (item.nombre.lowercased().contains(searchBar.text!.lowercased())) {
                               self.carteles.append(item)
                           }
                       }
                            
                       if (searchBar.text!.isEmpty) {
                           self.carteles = self.busquedaCarteles
                       }
                       self.collectionView.reloadData()
       }
      */

        
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           self.carteles.removeAll()
                
           for item in self.busquedaCarteles {
               if (item.nombre.lowercased().contains(searchBar.text!.lowercased())) {
                   self.carteles.append(item)
               }
           }
                
           if (searchBar.text!.isEmpty) {
               self.carteles = self.busquedaCarteles
           }
           self.collectionView.reloadData()
       }
    
    
    @IBAction func regresar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    

}
