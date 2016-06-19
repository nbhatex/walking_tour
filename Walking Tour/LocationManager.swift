//
//  LocationManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 20/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import MapKit

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager
    var mapView:MKMapView! {
        didSet {
            if authorized {
                mapView.showsUserLocation = true
            }
        }
    }
    var authorized:Bool
    
    var placeSelectionDelegate:PlaceSelectionDelegate!
    
    static let sharedInstance = LocationManager()
    
    private override init() {
        
        locationManager = CLLocationManager()
        authorized = false
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .Authorized:
            authorized = true
        case .AuthorizedWhenInUse, .Denied, .NotDetermined, .Restricted:
            locationManager.requestAlwaysAuthorization()
        }
        
    }

    
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            authorized = true
        case .AuthorizedWhenInUse, .Denied, .NotDetermined, .Restricted:
            print("permission not given")
        }
    }
    
    func addGeoFencesForPlace(walk:Walk) {
        let places = walk.places
        
        for place in places! {
            let place = (place as? Place)!
            let region = CLCircularRegion(center: place.coordinate, radius: 10, identifier: "\(place.id)")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let placeId = Int(region.identifier)
        if let delegate = placeSelectionDelegate {
            let content = ContentManager.sharedInstance.getContent(placeId!)
            delegate.placeSelected(content)
        }
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        standardDefaults.setInteger(placeId!, forKey: "LastSeenPlaceId")
        
    }
    
    func clearLocationData() {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        standardDefaults.removeObjectForKey("LastSeenPlaceId")
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                locationManager.stopMonitoringForRegion(circularRegion)
            }
        }
    }
}