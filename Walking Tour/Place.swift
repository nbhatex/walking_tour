//
//  POI.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class Place: NSManagedObject {
    @NSManaged var id:NSNumber
    @NSManaged var longitude:NSNumber
    @NSManaged var latitude:NSNumber
    @NSManaged var seqno:NSNumber
    
    @NSManaged var pathToNextPlace:NSOrderedSet
    
    @NSManaged var walk:Walk?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: context)
        super.init(entity: entity!,insertIntoManagedObjectContext:context)
      
        if let lng = dictionary["longitude"] as? Double {
            longitude = lng
        } else {
            longitude = 0.0
        }
        if let lat = dictionary["latitude"] as? Double {
            latitude = lat
        } else {
            latitude = 0.0
        }

        //pathToNextPlace = NSOrderedSet()
        var coordinates = [Coordinate]()
        if let points = dictionary["pathToNextPOI"] as? [[String:AnyObject]] {
            for point in points {
                let coordinate = Coordinate(dictionary: point,context: context)
                coordinates.append(coordinate)
            }
        }
        pathToNextPlace = NSOrderedSet(array: coordinates)
        
        if let placeId = dictionary["id"] as? Int {
            id = placeId
        } else {
            id = -1
        }
        
        if let sequenceNo = dictionary["poi_id"] as? Int {
            seqno = sequenceNo
        } else {
            seqno = 1
        }
    }
    
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude:Double(latitude), longitude:Double(longitude))
    }
    
    func getBoundingBox() -> BBox {
        
        //let fetchRequest = NSFetchRequest(entityName: "Place")
        //fetchRequest.predicate = NSPredicate(format: "id = %d", placeId)
        //do {
        //    let places = try sharedContext.executeFetchRequest(fetchRequest) as? [Place]
        //    let place = places?.first
            
            let bBox = BBox(latitudeDelta: 0.0015, longitudeDelta: 0.0015, centerLatitude: Double(latitude), centerLongitude: Double(longitude))
            
            return bBox
            
        //} catch {
        //    print(error)
        //}
        
        //return BBox(latitudeDelta: 1, longitudeDelta: 1, centerLatitude: 0, centerLongitude: 0)
    }
    

}