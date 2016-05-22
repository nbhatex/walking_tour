//
//  MapController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 02/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import MapKit

class MapController:UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var geoDataManager:GeoDataManager {
        return GeoDataManager.sharedInstance
    }
    
    var contentManager:ContentManager {
        return ContentManager.sharedInstance
    }
    
    override func viewDidLoad() {
        
        addPlaceAnnotations()
        
        addPath()
        mapView.delegate = self
        
        LocationManager.sharedInstance.mapView = mapView
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let placeId = standardUserDefaults.valueForKey("LastSeenPlaceId") as? Int
        if placeId != nil {
            setMapRegionWalk(placeId!)
        } else {
            setMapRegionPreview()
        }
        
    }
    
    func addPlaceAnnotations() {
        /*let standardDefaults = NSUserDefaults.standardUserDefaults()
        let walkId = standardDefaults.valueForKey("CurrentWalkId") as? String
        let places = WalkManager.sharedInstance.getWalk(walkId!)?.places*/
        let places = GeoDataManager.sharedInstance.getPlaces()
        var annotations = [MKPointAnnotation]()
        for place in places {
            let annotation = PlaceAnnotation(id: Int(place.id))
            annotation.title = contentManager.getContent(Int(place.id))!.title
            annotation.coordinate = place.coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func setMapRegionPreview() {
        let bounds = geoDataManager.getBounds()
        let center = CLLocationCoordinate2D(latitude: bounds.centerLatitude, longitude: bounds.centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: bounds.latitudeDelta * 1.2 , longitudeDelta: bounds.longitudeDelta * 1.2)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
    }
    
    func setMapRegionWalk(placeId:Int) {
        let bBox = geoDataManager.getBoundingBox(placeId)
        let center = CLLocationCoordinate2D(latitude: bBox.centerLatitude, longitude: bBox.centerLongitude)
        let span = MKCoordinateSpan(latitudeDelta: bBox.latitudeDelta * 1.2 , longitudeDelta: bBox.longitudeDelta * 1.2)
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
}