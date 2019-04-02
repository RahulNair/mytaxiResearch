//
//  MapViewController.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let regionRadius: CLLocationDistance = 2000
    var intialLocation : CLLocation?
    var locationManager : CLLocationManager?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager  = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }else{
            return
        }
        
        
        mapView.showsUserLocation = true
        
        
    }

}

extension MapViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        centerMapOnLocation(locationCordinates: locValue)
    }
    
    func centerMapOnLocation(locationCordinates: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: locationCordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
