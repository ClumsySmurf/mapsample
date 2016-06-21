//
//  MapService.swift
//  MapDemo
//
//  Created by John Hamilton on 6/19/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import Foundation


class MapService: NSObject {
    
    
    class func getAnnotations() -> AnyObject? {
        
        guard let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
           else { return nil }
        
        do {
            let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            
            return jsonData
        }
        
        catch {
            print("\(error)")
            return nil
        }
    }
}