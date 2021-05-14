//
//  MapViewPlus
//
//  Created by Okhan Okbay on 10/03/2018
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 okhanokbay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import MapKit

public protocol MapViewPlusDelegate: MKMapViewDelegate {
    // You can return different images for different annotations, as you see.
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus ) -> UIImage
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, imageFor medianos: AnnotationPlus) -> UIImage
    
    // You must return a CalloutViewPlusProtocol conformant here, because, while MapViewPlus is building the callout view, it uses the conformance.
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus
    
    //MEDIANOS FORAMTOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, calloutViewFor medianosView: AnnotationViewPlus) -> CalloutViewPlus
	
	// Optional
	// This method name is chosen to prevent conflicts.
	// If you don't want any callbacks, then skip this method.
    func mapView(_ mapView: MapViewPlus, didAddAnnotations annotations: [AnnotationPlus])
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, didAddAnnotations medianos: [AnnotationPlus])
}

    

public extension MapViewPlusDelegate {
	func mapView(_ mapView: MapViewPlus, didAddAnnotations medianos: [AnnotationPlus]) {}
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, didAddAnnotations medianos: [AnnotationPlus]) {}
}



public protocol CalloutViewCustomizerDelegate: class {
    // Center for callout view is the position of calloutview related to its annotation view.
    // You can return any CalloutViewPlusCenter options here
    // defaultCenter makes callout view centered related to annotation view. If you don't conform to this protocol, defaultCenter is used.
    // customCenter lets you customize the position of callout view related to annotation view
    func mapView(_ mapView: MapViewPlus, centerForCalloutViewOf annotationView: AnnotationViewPlus) -> CalloutViewPlusCenter
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, centerForCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewPlusCenter
    
    // Bound for callout view is actually the size of the callout view.
    // You can return any CalloutViewPlusBound options here
    // defaultBounds makes callout view as the same size as it is in the interface builder, or the same size as how you built it.
    // customBounds lets you customize the size of callout view
    func mapView(_ mapView: MapViewPlus, boundsForCalloutViewOf annotationView: AnnotationViewPlus) -> CalloutViewPlusBound
    
    //MEDIANOS FORMATOS
    func mapVieMedianos(_ mapViewMedianos: MapViewPlus, boundsForCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewPlusBound
    
    // Optional
    // It sets the negative inset for anchor view
    func mapView(_ mapView: MapViewPlus, insetFor calloutView: CalloutViewPlus) -> CGFloat
	
	// Optional
	// Return the desired animation type to be used while showing the callout view
	func mapView(_ mapView: MapViewPlus, animationTypeForShowingCalloutViewOf annotationView: AnnotationViewPlus) -> CalloutViewShowingAnimationType
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, animationTypeForShowingCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewShowingAnimationType
	
	// Optional
	// Return the desired animation type to be used while hiding the callout view
	func mapView(_ mapView: MapViewPlus, animationTypeForHidingCalloutViewOf annoationView: AnnotationViewPlus) -> CalloutViewHidingAnimationType
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, animationTypeForHidingCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewHidingAnimationType
}

public extension CalloutViewCustomizerDelegate {
    func mapView(_ mapView: MapViewPlus, insetFor calloutView: CalloutViewPlus) -> CGFloat {
        return mapView.defaultInsetForCalloutView
    }
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, insetFor calloutView: CalloutViewPlus) -> CGFloat {
        return mapViewMedianos.defaultInsetForCalloutView
    }

    func mapView(_ mapView: MapViewPlus, animationTypeForShowingCalloutViewOf annotationView: AnnotationViewPlus) -> CalloutViewShowingAnimationType {
		return CalloutViewShowingAnimationType.fromBottom
	}
    
    //MEDIANOS FORAMTOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, animationTypeForShowingCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewShowingAnimationType {
        return CalloutViewShowingAnimationType.fromBottom
    }
	
    func mapView(_ mapView: MapViewPlus, animationTypeForHidingCalloutViewOf annoationView: AnnotationViewPlus) -> CalloutViewHidingAnimationType {
		return CalloutViewHidingAnimationType.toBottom
	}
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, animationTypeForHidingCalloutViewOf medianosView: AnnotationViewPlus) -> CalloutViewHidingAnimationType {
        return CalloutViewHidingAnimationType.toBottom
    }
}

public protocol AnchorViewCustomizerDelegate: class {
	// Optional
    // The height returned from this method will be used as the height of the anchor triangle
    // Line heights will be calculated upon this value to generate a equilateral triangle
    // Every anchor is an equilateral triangle
    func mapView(_ mapView: MapViewPlus, heightForAnchorOf calloutView: CalloutViewPlus) -> CGFloat
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, heightForAnchorOf calloutView: CalloutViewPlus) -> CGFloat
    
    //Optional
    // The color returned from this method will be used to fill the anchor triangle.
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor
}

public extension AnchorViewCustomizerDelegate {
    
	func mapView(_ mapView: MapViewPlus, heightForAnchorOf calloutView: CalloutViewPlus) -> CGFloat {
		return mapView.defaultHeightForAnchors
	}
    
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, heightForAnchorOf calloutView: CalloutViewPlus) -> CGFloat {
        return mapViewMedianos.defaultHeightForAnchors
    }
	
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor {
        return mapView.defaultFillColorForAnchors
    }
    //MEDIANOS FORMATOS
    func mapViewMedianos(_ mapViewMedianos: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor {
        return mapViewMedianos.defaultFillColorForAnchors
    }
}
