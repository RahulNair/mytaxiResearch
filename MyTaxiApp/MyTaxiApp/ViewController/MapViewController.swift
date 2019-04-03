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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var appDelegate : AppDelegate?
    let regionRadius: CLLocationDistance = 5000
    var intialLocation : CLLocation?
    var locationManager : CLLocationManager?
    var vechileDataList : [MTVechileDataModel] = []
    var annotationList   : [TaxiAnnotation] = []
    
    
    var currentCordinate : CLLocationCoordinate2D?
    var boundCordinate : CLLocationCoordinate2D?
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager?.stopUpdatingLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager?.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        //mapView.setUserTrackingMode(.followWithHeading, animated: false)

        
        appDelegate =  (UIApplication.shared.delegate as! AppDelegate)
        
        
        locationManager  = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager?.startUpdatingLocation()
           // locationManager?.startUpdatingHeading()
            

        }else{
            return
        }
        
        
        mapView.showsUserLocation = true

        
    }
    
    func loadDataOnMap()  {
        removeAllMarkers()
        
        for element in vechileDataList{
            let coord = CLLocationCoordinate2D(latitude: element.coordinate.latitude, longitude: element.coordinate.longitude)
            let annotation = TaxiAnnotation(vechileObj: element, coordinate: coord)
            annotationList.append(annotation)
            mapView.addAnnotation(annotation)
            
        }
        
        
    }
    
    func loadData(completion:  @escaping (MTError?) -> Void)  {
        weak var w_self = self
        let url = AppConstants.hostURL
            
        let params : MTParams = ["p2Lat":String(Double(currentCordinate?.latitude ?? 0.0)) ,
                                 "p2Lon": String(Double(currentCordinate?.longitude ?? 0.0)),
                                 "p1Lat": String(Double(boundCordinate?.latitude ?? 0.0)),
                                 "p1Lon": String(Double(boundCordinate?.longitude ?? 0.0))]
        
        appDelegate?.networkManagerSharedInstance?.performNetworkOperation(method: MTHTTPMethod.get, urlString: url, params: params, header: nil, completion: { (result) in
            switch result {
            case .success(let value):
                print(value)
                do {
                    let decoder = JSONDecoder()
                    let root = try decoder.decode(Root.self, from: value)
                    w_self?.vechileDataList = root.poiList
                    completion(nil)
                } catch let err {
                    print("Err", err)
                    completion(err as! MTError)
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    
    func calculateBoundCordinates(){
        let nePoint = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.origin.y)
        let swPoint = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.maxY)
         currentCordinate = mapView.convert(nePoint, toCoordinateFrom: mapView)
         boundCordinate = mapView.convert(swPoint, toCoordinateFrom: mapView)
    }
    
    func removeAllMarkers()  {
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
    }
}


extension MapViewController : MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("----regionDidChangeAnimated- ")
        
        weak var w_self = self

        calculateBoundCordinates()
        
        loadData { (err) in
            if err != nil{
                print("error occurred")
            }else{
                DispatchQueue.main.async {
                    w_self?.loadDataOnMap()
                    
                }
                
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        if anView == nil {
            anView = TaxiAnnotationView(annotation: annotation as! TaxiAnnotation, reuseIdentifier: identifier)
        } else {
            anView?.annotation = annotation
        }

        return anView
        
 
    }
}

extension MapViewController : CLLocationManagerDelegate{
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
       // print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager?.stopUpdatingLocation()

         centerMapOnLocation(locationCordinates: locValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
//        updateAnnotationHeader(heading: newHeading)
    }
    
    
    
    func centerMapOnLocation(locationCordinates: CLLocationCoordinate2D) {
        
        let coordinateRegion = MKCoordinateRegion(center: locationCordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func updateAnnotationHeader(heading: CLHeading)  {

        for annotations in mapView.annotations{
            if let view = mapView.view(for: annotations) as? TaxiAnnotationView {
                view.updateImageHeadingq(heading: heading)
            }
            
        
        }
    }
}

class TaxiAnnotation: NSObject, MKAnnotation {
    let vechileObj: MTVechileDataModel?
    let coordinate: CLLocationCoordinate2D
    
    init(vechileObj: MTVechileDataModel, coordinate: CLLocationCoordinate2D) {
        self.vechileObj = vechileObj
        self.coordinate = coordinate
        super.init()
    }
    
    //    var subtitle: String? {
    //        return locationName
    //    }
}

class TaxiAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation  , reuseIdentifier: reuseIdentifier)
        
        let t_annotation = annotation as! TaxiAnnotation
        print(t_annotation.vechileObj?.heading)
        let icon_img = UIImage(named: "taxi_icon")
        self.image = icon_img!.imageRotatedByDegrees(degrees: CGFloat(t_annotation.vechileObj?.heading ?? 0.0) - 90.0, flip: false)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    func updateImageHeadingq(heading : CLHeading)  {
        
        let img =  self.image?.imageRotatedByDegrees(degrees: CGFloat(-(heading.magneticHeading.magnitude)), flip: false)
        self.image  = nil
        self.image = img
    }
}


extension UIImage {
    
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat.pi)
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat.pi
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        
        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        
        bitmap?.draw(cgImage!, in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

