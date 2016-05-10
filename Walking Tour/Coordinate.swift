//
//  Coordinate.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import MapKit

struct Coordinate {
    var latitude:Double
    var longitude:Double
    var seqno:Int
    
    init(latitude:Double,longitude:Double,seqno:Int){
        self.latitude = latitude
        self.longitude = longitude
        self.seqno = seqno
    }
    
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
        if let order = dictionary["seqno"] as? Int {
            seqno = order
        } else {
            seqno = 1
        }

    }
    
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
    }
}