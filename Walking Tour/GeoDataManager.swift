//
//  GeoDataManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class GeoDataManager {
    static let  sharedInstance = GeoDataManager()
    private init() { }
    
    func loadData(walk:Walk) {
        let dataAsset = NSDataAsset(name: "geo_json")
        var places = [Place]()
        do {
            if let data = dataAsset?.data {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                let placeDictionaries = parsedData as! [[String:AnyObject]]
                for placeDictionary in placeDictionaries {
                    let place = Place(dictionary: placeDictionary,context: sharedContext)
                    place.walk = walk
                    places.append(place)
                }
                let mutablePlaces = walk.places?.mutableCopy() as! NSMutableOrderedSet
                mutablePlaces.addObjectsFromArray(places)
                walk.places = mutablePlaces.copy() as? NSOrderedSet
                
                //CoreDataStackManager.sharedInstance.saveContext()
            }
            
        } catch  {
            print(error)
        }
    }
    

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    func getPlace(placeId:Int) -> Place? {
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "id = %d", placeId)
        do {
            let places = try sharedContext.executeFetchRequest(fetchRequest) as? [Place]
            let place = places?.first
            return place!
        } catch {
            print(error)
        }
        return nil
    }
    
}

