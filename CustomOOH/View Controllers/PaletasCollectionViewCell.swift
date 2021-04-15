//
//  PaletasCollectionViewCell.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import UIKit

class PaletasCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nombreCartel: UILabel!
    @IBOutlet weak var condicion: UILabel!
    @IBOutlet weak var fechaUltRegistro: UILabel!
    
    public var categoria: String!
    public var cliente: String!
    public var municipio: String!
    public var estado: String!
    public var direccion: String!
    public var detalles: String!
    public var coordenadasX: String!
    public var coordenadasY: String!
}
