//
//  BaseAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import RealmSwift
import ObjectMapper


class BaseAnnotationModel : Object, Mappable{
    
    dynamic var x: Double = 0
    dynamic var y: Double = 0
    dynamic var title: String?
    dynamic var subTitle: String?
    

    
    // Error Handling
    enum InputError: ErrorType {
        case InvalidCoordinates
    }
    
    
    required convenience init?(_ map : Map) {
        self.init();
    }
    
    func mapping(map: Map) {
        x <- map["x"]
        y <- map["y"]
        title! <- map["title"]
        subTitle <- map["subTitle"]
    }
    
    convenience init(coordinates: (x:Double, y:Double),
                     title: String?, subTitle: String?) throws {
    
        self.init()
        
        guard coordinates.x != 0 && coordinates.y != 0 else {
            throw InputError.InvalidCoordinates
        }

        self.x = coordinates.x
        self.y = coordinates.y
        self.title = title
        self.subTitle = subTitle
    
    }
    
    convenience init(coordinates: (x:Double, y:Double), title: String?) throws {
        
        try self.init(coordinates: coordinates,
                      title: title,
                      subTitle: nil)
    }
    
    convenience init(coordinates: (x:Double, y:Double)) throws {
        try self.init(coordinates: coordinates,
                      title: nil,
                      subTitle: nil)
    }

    
}
