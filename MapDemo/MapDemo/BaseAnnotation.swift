//
//  BaseAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import Mapbox


class BaseAnnotation : NSObject, MGLAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var identifier: String?
    var title: String?
    var subTitle: String?
    

    
    // Error Handling
    enum InputError: ErrorType {
        case InvalidCoordinates
        case MissingIdentifier
    }
    
    
    
    init(coordinates: CLLocationCoordinate2D, identifier: String?, title: String?, subTitle: String?) throws {
        
        guard CLLocationCoordinate2DIsValid(coordinates) else {
            throw InputError.InvalidCoordinates
        }
        
        guard identifier != nil else {
            throw InputError.MissingIdentifier
        }
        
        
        self.identifier = identifier
        self.coordinate = coordinates
        self.title = title
        self.subTitle = subTitle
    
    }
    
    convenience init(coordinates: CLLocationCoordinate2D, identifier: String?, title: String?) throws {
        
        try self.init(coordinates: coordinates,
                      identifier: identifier,
                      title: title, subTitle: nil)
    }
    
    convenience init(coordinates: CLLocationCoordinate2D, identifier: String?) throws {
        try self.init(coordinates: coordinates,
                      identifier: identifier,
                      title: nil, subTitle: nil)
    }
    
    
    
    
    
    
    
    
}
