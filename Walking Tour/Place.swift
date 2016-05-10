//
//  POI.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import MapKit

class Place {
    var id:Int
    var longitude:Double
    var latitude:Double
    
    var pathToNextPlace:[Coordinate]
    
    init(dictionary:[String:AnyObject]) {
        if let lat = dictionary["latitude"] as? Double {
            latitude = lat
        } else {
            latitude = 0.0
        }
        if let lng = dictionary["longitude"] as? Double {
            longitude = lng
        } else {
            longitude = 0.0
        }
        pathToNextPlace = [Coordinate]()
        if let points = dictionary["pathToNextPOI"] as? [[String:AnyObject]] {
            for point in points {
                let coordinate = Coordinate(dictionary: point)
                pathToNextPlace.append(coordinate)
            }
        }
        if let placeId = dictionary["id"] as? Int {
            id = placeId
        } else {
            id = -1
        }
    }
    
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
    }
    

}