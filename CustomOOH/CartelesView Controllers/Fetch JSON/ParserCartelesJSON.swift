//
//  ParserCartelesJSON.swift
//  CustomOOH
//
//  Created by Javier Flores on 14/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import Foundation


class ParserCartelesJSON: Decodable {
    
  
    public var nombre: String!
    public var categoria: String!
    public var cliente: String!
    public var municipio: String!
    public var estado: String!
    public var direccion: String!
    public var detalles: String!
    
    public var media: [MediaParserJSON]!
    public var revisiones: [RevisionesParserJSON]!
    
    public var fecha_creacion: String!
    public var condicion: String!
    
    //public var coordenadasX: Number!
    //public var coordenadasY: Number!
}
