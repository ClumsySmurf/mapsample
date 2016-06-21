//
//  ImageAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import UIKit
import ObjectMapper
import Mapbox


class ImageAnnotationModel: BaseAnnotationModel {
    
    dynamic var imageName: String?
    
    enum InputError: ErrorType {
        case InvalidImage
    }
    
    

    required convenience init?(_ map : Map) {
        self.init();
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        imageName <- map["image"]
    }
    
  
    convenience init(imageName: String?, coordinates: (x:Double, y:Double), title: String?, subTitle: String?) throws {
        
        
        self.init()
        
        guard imageName != nil else {
            throw InputError.InvalidImage
        }
        
        guard coordinates.x != 0 && coordinates.y != 0 else {
            throw InputError.InvalidCoordinates
        }
        
        
        self.x = coordinates.x
        self.y = coordinates.y
        self.title = title
        self.subTitle = subTitle
        
       
        
        self.imageName = imageName
    }
    
    convenience init(imageName: String?,
                     coordinates: (x:Double, y:Double),
                     title: String?) throws {
        
        try self.init(imageName: imageName,
                      coordinates: coordinates,
                      title: title,
                      subTitle: nil)
    }
    
    convenience init(imageName: String?,
                     coordinates: (x:Double, y:Double),
                     identifier: String?) throws {
        
        try self.init(imageName: imageName,
                      coordinates: coordinates,
                      title: nil,
                      subTitle: nil)
    }
    

}
