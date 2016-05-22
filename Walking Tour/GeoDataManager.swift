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
                walk.places = NSOrderedSet(array: places)
                CoreDataStackManager.sharedInstance.saveContext()
            }
            
        } catch  {
            print(error)
        }
    }
    
    func getPlaces() -> [Place] {
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "seqno", ascending: true)]
        do {
            let places = try sharedContext.executeFetchRequest(fetchRequest) as? [Place]
            return places!
        } catch {
            print(error)
        }
        return [Place]()
    }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    func getBounds()-> BBox{
        var maxLat = 0.0, minLat = 90.0, maxLng = 0.0, minLng = 180.0
        let places = getPlaces()
        for place in places {
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
    
    func getBoundingBox(placeId:Int) -> BBox {
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "id = %d", placeId)
        do {
            let places = try sharedContext.executeFetchRequest(fetchRequest) as? [Place]
            let place = places?.first
            
            let bBox = BBox(latitudeDelta: 0.0015, longitudeDelta: 0.0015, centerLatitude: Double((place?.latitude)!), centerLongitude: Double((place?.longitude)!))
            
            return bBox
            
        } catch {
            print(error)
        }
        
        return BBox(latitudeDelta: 1, longitudeDelta: 1, centerLatitude: 0, centerLongitude: 0)
    }
    
    //TODO: needs to be a lazy variable
    func getConnectedPath()->[CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        let places = getPlaces()
        for place in places {
            coordinates.append(place.coordinate)
            for point in place.pathToNextPlace {
                coordinates.append(point.coordinate)
            }
        }
        return coordinates
    }
}

struct  BBox {
    var latitudeDelta: Double,longitudeDelta: Double, centerLatitude: Double, centerLongitude: Double
    init(latitudeDelta: Double,longitudeDelta: Double, centerLatitude: Double, centerLongitude: Double) {
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
    }
}