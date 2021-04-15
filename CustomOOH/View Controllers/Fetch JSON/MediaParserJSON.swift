//
//  MediaParserJSON.swift
//  CustomOOH
//
//  Created by Javier Flores on 15/04/21.
//  Copyright © 2021 mx.itesm.A01651678. All rights reserved.
//

import Foundation


public struct MediaParserJSON:  Decodable {
    
    public var img_name: String!
    public var url: String!
    public var fecha_tomada: String!
}
