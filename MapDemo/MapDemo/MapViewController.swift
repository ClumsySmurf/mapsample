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
import MapKit

    
class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var dropPinBttn: UIButton!
    @IBOutlet weak var findLocationBttn: UIButton!
    
    
    lazy var mapOperations = [NSIndexPath:NSOperation]()
    lazy var mapOperationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    var jsonData:AnyObject? = nil
    
    
    /* Used for demo but we really don't use this object */
    var annotationResults:Array<MGLAnnotation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtons()
        setupMap()
        mapView.delegate = self
        

        
        // Uncomment below to make base json models
        //createSampleAnnotationModels()
        
        // 1) Uncomment lines below to load default items into realm on background
        //loadAnnotationsIntoRealm()
        
        // 2) Comment line above, and uncomment line below to start playing around
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
        
        do {
            
            let coords = mapView.camera.centerCoordinate
            
            let realm = try Realm();
            
            
            let annotation = try ImageAnnotationModel(imageName: "pin-poi-fishing", coordinates: (x: coords.latitude, y: coords.longitude), identifier: "Dropped Pin")
            
            try realm.write({
                realm.add(annotation)
            })
            
            
            annotationResults?.append(annotation)
            
            mapView.addAnnotation(annotation)
        }
        catch {
            print("Error adding \(error)")
        }
    }
    
}

extension MapViewController {

    
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
    
    
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        if let region:MGLCoordinateBounds? = mapView.visibleCoordinateBounds {
        
            /*! Cancel any current update operations */
            mapOperationQueue.cancelAllOperations()
            
        
            var idList = [String]()
            
            if self.mapView.annotations != nil {
                
                idList = IDSForAnnotationList(self.mapView.annotations!);

            } else {
                print("No annotations to load")
            }

            
            let operation = NSBlockOperation(block: { 
                self.updateAnnotationsAroundUser(region!, center: mapView.centerCoordinate, currentIDS: idList)
            })
            
            mapOperationQueue.addOperation(operation)
            
        }
        
    
    }
    
}



