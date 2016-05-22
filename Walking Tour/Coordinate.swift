//
//  Coordinate.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class Coordinate:NSManagedObject {
    @NSManaged var latitude:NSNumber
    @NSManaged var longitude:NSNumber
    @NSManaged var seqno:NSNumber
    
    /*init(latitude:Double,longitude:Double,seqno:Int){
        super.init()
        self.latitude = latitude
        self.longitude = longitude
        self.seqno = seqno
    }*/
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject], context:NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Coordinate", inManagedObjectContext: context)
        super.init(entity: entity!,insertIntoManagedObjectContext:context)
        
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
        return CLLocationCoordinate2D(latitude:Double(latitude), longitude:Double(longitude))
    }
}