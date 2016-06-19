//
//  ImageAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import UIKit
import Mapbox

class ImageAnnotation: BaseAnnotation {
    
    var image: UIImage?
    
    enum InputError: ErrorType {
        case InvalidImage
    }
    
    convenience init(image: UIImage?, coordinates: CLLocationCoordinate2D, identifier: String?, title: String?, subTitle: String?) throws {
        
        guard image != nil else {
            throw InputError.InvalidImage
        }
        
        try self.init(coordinates: coordinates,
                      identifier: identifier,
                      title: title, subTitle: subTitle)
        
        self.image = image
    }
    
    convenience init(image: UIImage?, coordinates: CLLocationCoordinate2D, identifier: String?, title: String?) throws {
        
        try self.init(image: image, coordinates: coordinates, identifier: identifier, title: title, subTitle: nil)
    }
    
    convenience init(image: UIImage?, coordinates: CLLocationCoordinate2D, identifier: String?) throws {
        
        try self.init(image: image, coordinates: coordinates, identifier: identifier, title: nil, subTitle: nil)
    }
    

}
