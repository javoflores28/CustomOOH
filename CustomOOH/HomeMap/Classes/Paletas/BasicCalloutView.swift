//
//  BasicCalloutView.swift
//  MapViewPlus
//
//  Created by Okhan on 07/03/2018.
//  Copyright © 2018 okhanokbay. All rights reserved.
//

import UIKit
import MapViewPlus

public protocol BasicCalloutViewModelDelegate: class {
    func detailButtonTapped(withTitle title: String, image: UIImage, direccion: String)
}

class BasicCalloutView: UIView {
	
	weak var delegate: BasicCalloutViewModelDelegate?
	

	
    @IBOutlet weak var direccion: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    //@IBOutlet weak var button: UIButton!
    
    @IBOutlet var button: UIButton!
    
    @IBAction func buttonTouchDown(_ sender: Any) {
        delegate?.detailButtonTapped(withTitle: label.text!, image: imageView.image!, direccion: direccion.text!)
    }
}
    
extension BasicCalloutView: CalloutViewPlus{
	func configureCallout(_ viewModel: CalloutViewModel) {
		let viewModel = viewModel as! BasicCalloutViewModel
		
		label.text = viewModel.title
		imageView.image = viewModel.image
        direccion.text =  viewModel.direccion
	}
}
