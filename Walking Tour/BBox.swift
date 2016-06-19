//
//  BBox.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 19/06/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation

struct  BBox {
    var latitudeDelta: Double,longitudeDelta: Double, centerLatitude: Double, centerLongitude: Double
    init(latitudeDelta: Double,longitudeDelta: Double, centerLatitude: Double, centerLongitude: Double) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
    }
}