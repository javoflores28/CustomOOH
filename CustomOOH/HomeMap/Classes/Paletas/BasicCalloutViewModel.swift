//
//  BasicCalloutViewModel.swift
//  MapViewPlus
//
//  Created by Okhan on 07/03/2018.
//  Copyright © 2018 okhanokbay. All rights reserved.
//

import UIKit
import MapViewPlus

class BasicCalloutViewModel: CalloutViewModel {
	var title: String
	var image: UIImage
    var direccion: String
	
    init(title: String, image: UIImage, direccion: String) {
		self.title = title
		self.image = image
        self.direccion = direccion
	}
}
