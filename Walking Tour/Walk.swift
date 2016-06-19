//
//  Walks.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 21/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Walk: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name:String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: context)
        super.init(entity: entity!,insertIntoManagedObjectContext:context)
        self.name = name
        self.id = NSUUID().UUIDString
    }
    
    func getBounds()-> BBox{
        var maxLat = 0.0, minLat = 90.0, maxLng = 0.0, minLng = 180.0
        //let places = getPlaces(walk)
        for place in places! {
            let place = (place as? Place)!
            if maxLat < Double(place.latitude) {
                maxLat = Double(place.latitude)
            }
            if minLat > Double(place.latitude) {
                minLat = Double(place.latitude)
            }
            if maxLng < Double(place.longitude) {
                maxLng = Double(place.longitude)
            }
            if minLng > Double(place.longitude) {
                minLng = Double(place.longitude)
            }
        }
        let latitudeDelta = maxLat - minLat
        let longitudeDelta = maxLng - minLng
        
        let centerLatitude = (maxLat+minLat)/2
        let centerLongitude = (maxLng+minLng)/2
        
        print(latitudeDelta, longitudeDelta)
        
        return BBox(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta, centerLatitude: centerLatitude, centerLongitude: centerLongitude)
        
    }
    
    //TODO: needs to be a lazy variable
    func getConnectedPath()->[CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        for place in places! {
            let place = (place as? Place)!
            coordinates.append(place.coordinate)
            for point in place.pathToNextPlace {
                coordinates.append(point.coordinate)
            }
        }
        return coordinates
    }
    func getContents() -> [Content] {
        return (contents?.array as? [Content])!
    }
}
