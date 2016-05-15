//
//  PlaceAnnotation.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 11/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation:MKPointAnnotation {
    var placeId:Int
    init(id:Int) {
        placeId = id
    }
}
