//
//  GrandesFormatosViewController.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class GrandesFormatosViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    private var carteles: [ParserCartelesJSON]! = []
     
    private var busquedaCarteles: [ParserCartelesJSON]! = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: URL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data/grandes.json")!
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
            
            
           
           let cell: GrandesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellGrandes", for: indexPath) as! GrandesCollectionViewCell
           
           cell.nombreCartel.text = self.carteles[indexPath.item].nombre
           cell.detalles = self.carteles[indexPath.item].detalles
           
           cell.condicion.text = "Condición " + self.carteles[indexPath.item].condicion
           cell.fechaUltRegistro.text = self.carteles[indexPath.item].revisiones[0].fecha_revision
            
            //Coloar imagenes del JSON
            if let imageURL = URL(string: "http://martinmolina.com.mx/202111/equipo6/data" + carteles[indexPath.item].media[0].url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                        cell.img.image = image
                        }
                    }
                }
            }
           /*
             cell?.img.image = UIImage(named: carteles[indexPath.row])
             cell?.nombreCartel.text = cartele[indexPath.row]
          
           return cell!
           */
           
           return cell
         }
    
         //Enviar datos a pantalla de detalles
         func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             
                 let vc = storyboard?.instantiateViewController(withIdentifier: "DetallesCartelViewController") as? DetallesCartelViewController
                 
                 //vc?.name = cartelesArr[indexPath.row]
                 vc?.name = self.carteles[indexPath.item].nombre
                 vc?.detalles2 = self.carteles[indexPath.item].detalles
                 vc?.direccion2 = self.carteles[indexPath.item].direccion
                 vc?.condicion2 = "Condición: " + self.carteles[indexPath.item].condicion
                 vc?.ultimaRevision = "Última revisión: " + self.carteles[indexPath.item].revisiones[0].fecha_revision
                 vc?.imagen = carteles[indexPath.item].media[0].url
                   
               
                 self.navigationController?.pushViewController(vc!, animated: true)
                 
             }
       
      func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
       let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchBarGrandes", for: indexPath)
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
