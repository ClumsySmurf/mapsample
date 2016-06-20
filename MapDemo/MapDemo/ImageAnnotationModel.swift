//
//  ImageAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import UIKit
import ObjectMapper


class ImageAnnotationModel: BaseAnnotationModel {
    
    var imageName: String?
    
    enum InputError: ErrorType {
        case InvalidImage
    }
    
    required convenience init?(_ map : Map) {
        self.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        imageName! <- map["imageName"]
    }
    

    convenience init(imageName: String?, coordinates: (x:Double, y:Double), title: String?, subTitle: String?) throws {
        
        
        guard imageName != nil else {
            throw InputError.InvalidImage
        }
        
        try self.init(coordinates: coordinates,
                       title: title,
                       subTitle: subTitle)
        
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
