//
//  GeoDataManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import MapKit

class GeoDataManager {
    static let  sharedInstance = GeoDataManager()
    private var places:[Place]
    private init() {
        let dataAsset = NSDataAsset(name: "geo_json")
        places = [Place]()
        do {
            if let data = dataAsset?.data {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                let placeDictionaries = parsedData as! [[String:AnyObject]]
                for placeDictionary in placeDictionaries {
                    let place = Place(dictionary: placeDictionary)
                    places.append(place)
                }
            }
            
        } catch  {
            print(error)
        }
    }
    
    func getPlaces() -> [Place] {
        return places
    }
    
    //TODO: Needs to be a lazy variable
    
    func getBounds()-> (latitudeDelta: Double,longitudeDelta: Double, centerLatitude: Double, centerLongitude: Double) {
        var maxLat = 0.0, minLat = 90.0, maxLng = 0.0, minLng = 180.0
        for place in places {
            if maxLat < place.latitude {
                maxLat = place.latitude
            }
            if minLat > place.latitude {
                minLat = place.latitude
            }
            if maxLng < place.longitude {
                maxLng = place.longitude
            }
            if minLng > place.longitude {
                minLng = place.longitude
            }
        }
        let latitudeDelta = maxLat - minLat
        let longitudeDelta = maxLng - minLng
        
        let centerLatitude = (maxLat+minLat)/2
        let centerLongitude = (maxLng+minLng)/2
        
        print(latitudeDelta, longitudeDelta)
        
        return (latitudeDelta, longitudeDelta, centerLatitude, centerLongitude)
    }
    
    //TODO: needs to be a lazy variable
    func getConnectedPath()->[CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        for place in places {
            coordinates.append(place.coordinate)
            for point in place.pathToNextPlace {
                coordinates.append(point.coordinate)
            }
        }
        return coordinates
    }
}