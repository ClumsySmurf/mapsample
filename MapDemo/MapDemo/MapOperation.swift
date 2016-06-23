//
//  MapOperation.swift
//  MapDemo
//
//  Created by John Hamilton on 6/22/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import Foundation
import Mapbox
import RealmSwift

extension MapViewController {
    
    func updateAnnotationsAroundUser(location:MGLCoordinateBounds,
                                     center:CLLocationCoordinate2D, currentIDS:[String]) {
        
        do {
            let realm = try Realm()
            
            // Create predicates to test user region
            let predicate = self.predicateForRegion(location, center: center, latitudeKeyPath: "x", longitudeKeyPath: "y")
            
            let predicateFromIDS = NSPredicate(format: "id IN %@", currentIDS)
            
    
            
            // get a thread safe list of current annotations
            let currentAnnotations = realm.filter(parentType: BaseAnnotationModel.self, subclasses: [ImageAnnotationModel.self], predicate: predicateFromIDS)
            
            
            
            // Load annotations around user
            let annotations = realm.filter(parentType: BaseAnnotationModel.self, subclasses: [ImageAnnotationModel.self], predicate: predicate)
            
            
            
            if annotations.count > 0 {
                
                let setA = Set(currentAnnotations)
                let setB = Set(annotations)
                
                // All the annotations in set current set that are not in new set
                let toRemove = IDSForAnnotationList(Array(setA.subtract(setB)))
                
                // All the annotations that are in new set but not in old set
                let toAdd = IDSForAnnotationList(Array(setB.subtract(setA)))
               
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let realm = try Realm()
                        
                        
                        /*! Get Realm object list to add to map */
                        
                        let removeList = realm.filter(parentType: BaseAnnotationModel.self, subclasses: [ImageAnnotationModel.self], predicate:NSPredicate(format: "id IN %@", toRemove))
                            
                        let addList = realm.filter(parentType: BaseAnnotationModel.self, subclasses: [ImageAnnotationModel.self], predicate:NSPredicate(format: "id IN %@", toAdd))
                        
                        
                       
                        // Needed to remove actual objects from list
                        let removeReferenceList = self.mapView.annotations!.filter {
                            return removeList.contains($0 as! BaseAnnotationModel)
                        }
                        
                    
                        
                        self.mapView.removeAnnotations(removeReferenceList)
                        self.mapView.addAnnotations(addList)
                        
                        
                        if  self.mapView.annotations != nil {
                            print("Number of annotations \(self.mapView.annotations!.count) tried to remove: \(removeList.count) add: \(addList.count)  reference list \(removeReferenceList.count)")
                        }
                        
                    } catch {
                        print("Error \(error)")
                    }
                    
                  
                })
                
                
            }
                     } catch {
            print("error \(error)")
        }
        
            
        
    }
    
    
    /* Calucates area that we we want to grab annotations around */
    func predicateForRegion(bounds:MGLCoordinateBounds,
                            center:CLLocationCoordinate2D,
                            latitudeKeyPath:String,
                            longitudeKeyPath:String) -> String {
        
        
        let span = MGLCoordinateBoundsGetCoordinateSpan(bounds)
        
        let centerLatitude = center.latitude
        let centerLongitude = center.longitude
        
        let latitudeDelta = span.latitudeDelta
        let longitudeDelta = span.longitudeDelta
        
        let halfLatDelta = latitudeDelta/2;
        let halfLongDelta = longitudeDelta/2;
        
        let maxLat = centerLatitude + halfLatDelta;
        let minLat = centerLatitude - halfLatDelta;
        let maxLong = centerLongitude + halfLongDelta;
        let minLong = centerLongitude - halfLongDelta;
        
        
        return "x BETWEEN {\(minLat), \(maxLat)} AND y BETWEEN {\(minLong), \(maxLong)}"
        
        
    }
    
    
    func IDSForAnnotationList(annotations:Array<MGLAnnotation>) -> [String] {
        
        let idList = annotations.map { (ann:MGLAnnotation) -> String in
            
            if let result = ann as? BaseAnnotationModel {
                return result.id
            }
            
            return ""
        }
        
        return idList

    }

}