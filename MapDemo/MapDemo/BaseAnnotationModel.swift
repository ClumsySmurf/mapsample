//
//  BaseAnnotation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import RealmSwift
import ObjectMapper
import Mapbox


class BaseAnnotationModel : Object, Mappable, MGLAnnotation {
    
    dynamic var x: Double = 0
    dynamic var y: Double = 0
    dynamic var title: String?
    dynamic var subTitle: String?
    dynamic var id = 0
    

    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(x, y)
        }
    }
    
    // Error Handling
    enum InputError: ErrorType {
        case InvalidCoordinates
    }
    
    
    required convenience init?(_ map : Map) {
        self.init();
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func objectForMapping(map: Map) -> Mappable? {
        
        if let _:String = map["image"].value() {
            return ImageAnnotationModel(map)
        }
        
        return BaseAnnotationModel(map)
    }
    
    
    func mapping(map: Map) {
        x <- map["x"]
        y <- map["y"]
        title <- map["title"]
        subTitle <- map["subTitle"]
        id <- map["id"]
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
