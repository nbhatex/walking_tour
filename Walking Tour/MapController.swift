//
//  MapController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 02/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import MapKit
import Photos

class MapController:UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    var geoDataManager:GeoDataManager {
        return GeoDataManager.sharedInstance
    }
    
    var contentManager:ContentManager {
        return ContentManager.sharedInstance
    }
    
    var imageManager:PHImageManager {
        return PHImageManager()
    }
    
    override func viewDidLoad() {
        
        setMapRegion()
        
        addPlaceAnnotations()
        
        addPath()
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .Authorized:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            print("authorized")
        case .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            print("authorized when in use")
        case .Denied:
            print("denied")
            locationManager.requestWhenInUseAuthorization()
        case .NotDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
        case .Restricted:
            print("restricted")
            locationManager.requestWhenInUseAuthorization()
        }
        
        //locationManager.requestWhenInUseAuthorization()
        
    }
    
    func addPlaceAnnotations() {
        let places = geoDataManager.getPlaces();
        var annotations = [MKPointAnnotation]()
        for place in places {
            let annotation = PlaceAnnotation(id: place.id)
            annotation.title = contentManager.getContent(place.id)!.title
            annotation.coordinate = place.coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func setMapRegion() {
        let bounds = geoDataManager.getBounds()
        let center = CLLocationCoordinate2D(latitude: bounds.centerLatitude, longitude: bounds.centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: bounds.latitudeDelta * 1.2 , longitudeDelta: bounds.longitudeDelta * 1.2)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
    }
    
    func addPath() {
        var coordinates = geoDataManager.getConnectedPath()
        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    
    //MARK : Mapview delegate methods
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let lineOverlay = overlay as? MKPolyline {
           let renderer = MKPolylineRenderer(polyline: lineOverlay)
            renderer.strokeColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.8)
            renderer.lineWidth = 2.0
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print(annotation is PlaceAnnotation)
        if annotation is PlaceAnnotation {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            if let splitView = self.tabBarController?.viewControllers?.last as? SplitViewController {
                splitView.assignedDisplayMode = .PrimaryHidden
                if let placeAnnotation = annotationView.annotation as? PlaceAnnotation {
                    splitView.placeId = placeAnnotation.placeId
                }
            }
            self.tabBarController?.selectedIndex = 1
        }
    }
    //MARK : Location Manager
    
   
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //print("Latitude: \(location.coordinate.latitude). Longitude: \(location.coordinate.longitude).")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            print("authorized x")
        case .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            print("authorized when in use x")
        case .Denied:
            print("denied x")
        case .NotDetermined:
            print("not determined x")
        case .Restricted:
            print("restricted x")
        }
    }
    
}