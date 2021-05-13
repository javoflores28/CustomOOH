//
//  RevisionesParserJSON.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import Foundation

public struct RevisionesParserJSON: Decodable {
    
    public var condicion: String!
    public var nombre_supervisor: String!
    public var fecha_revision: String!
    //public var clienteactual: String!
    public var comentarios: String!
    
}
