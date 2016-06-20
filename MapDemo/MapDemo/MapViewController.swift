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
    
class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var dropPinBttn: UIButton!
    @IBOutlet weak var findLocationBttn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtons()
        setupMap()
        mapView.delegate = self
        
        // Uncomment below to make base json models
        createSampleAnnotationModels()
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
       // let b  = ""
    }
}

