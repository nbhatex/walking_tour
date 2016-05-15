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
        
        setMapRegion()
        
        addPlaceAnnotations()
        
        addPath()
        mapView.delegate = self
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
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        if let placeAnnotation = annotation as? PlaceAnnotation {
            let content = contentManager.getContent((placeAnnotation.placeId))
            if let photo = content.photos.first {
                    //TODO : Fix this to show image thumbnail
                let imageView = UIImageView(frame:CGRect(x: 0,y: 0,width: 32,height: 32))
                imageView.contentMode = .ScaleAspectFit
                imageView.image = UIImage(named: photo.title)
                pinView!.leftCalloutAccessoryView = imageView
                
            }
        }
        return pinView
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