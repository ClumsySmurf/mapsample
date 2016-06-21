//
//  ViewController.swift
//  MapDemo
//
//  Created by John Hamilton on 6/18/16.
//  Copyright © 2016 TLDR. All rights reserved.
//

import UIKit
import Mapbox
import ObjectMapper
import RealmSwift
    
class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var dropPinBttn: UIButton!
    @IBOutlet weak var findLocationBttn: UIButton!
    
    
    var jsonData:AnyObject? = nil
    
    var annotationResults:Array<MGLAnnotation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtons()
        setupMap()
        mapView.delegate = self
        
        // Uncomment below to make base json models
        //createSampleAnnotationModels()
        
        // Uncomment line below to load annotations into realm
        //loadAnnotationsIntoRealm()
        
        loadRealmObjectAnnotations()
        
        mapView.addAnnotations(annotationResults!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createSampleAnnotationModels() {
        
        let annotation:BaseAnnotationModel?
        
        do {
            
            annotation = try BaseAnnotationModel.init(coordinates: (x: 37.3302, y: -122.0342),
                                                  title: "standard annotation",
                                                  subTitle: "subtitle")
            
            let annotationJSON = Mapper().toJSONString(annotation!, prettyPrint: false)
            
            print(annotationJSON)
            
            
        } catch {
            print("\(error)")
        }
    }
    
    func loadAnnotationsIntoRealm() {
        self.jsonData = MapService.getAnnotations()
        
        if (self.jsonData != nil) {
            
            if let annotations = Mapper<BaseAnnotationModel>().mapArray(self.jsonData) {
                
                saveRealmObjects(annotations)
                
            }
            
        }
        
    }
    
    func saveRealmObjects(annotations:[Object]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { 
            
            do {
                let realm = try Realm();
                
                realm.beginWrite()
                
               
                for a in annotations {
                     realm.add(a, update: true)
                }
                
                try realm.commitWrite()
            }
            catch {
                print("Realm Error: \(error)")
            }
        }
    }
    
    func loadRealmObjectAnnotations() {
        
        do {
            let realm = try Realm()
            
            annotationResults = realm.filter(parentType: BaseAnnotationModel.self, subclasses: [ImageAnnotationModel.self], predicate: nil)
            
            
        } catch {
            print("error \(error)")
        }
    }
    
    func setupMap() {
        mapView.showsUserLocation = true
    }
    
    /*! Just round our buttons */
    func adjustButtons() {
        findLocationBttn.layer.cornerRadius = CGRectGetWidth(findLocationBttn.frame) / 2.0
        dropPinBttn.layer.cornerRadius = CGRectGetWidth(dropPinBttn.frame) / 2.0
    }

    
    @IBAction func findLocationTouchUpInsideAction(sender: AnyObject) {
        
        
        /*! Make sure user's coordinates and location can be found */
        guard let coords = mapView.userLocation?.coordinate
            where mapView.userLocation != nil
        else {
            return;
        }
        
        /*! Set and zoom to user's location */
        mapView.setCenterCoordinate(coords, animated: true)
        mapView.setZoomLevel(15.0, animated: true)
        
    }

    @IBAction func dropPinTouchUpInsideAction(sender: AnyObject) {
    }
    
}

extension MapViewController {
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
       
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
       
        
        if (annotation is ImageAnnotationModel) {
            
            guard let imageAnnotation = annotation as? ImageAnnotationModel else {
                return nil
            }
            
            var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(imageAnnotation.imageName!)
            
            
            var image = UIImage(named:imageAnnotation.imageName!)!
                
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imageAnnotation.imageName!)
        
            return annotationImage
            
        }
        
        return nil

    }
        

    
}

