//
//  WalkManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 21/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import CoreData

class WalkManager {
    
    static let sharedInstance = WalkManager()
    private init() { }
    
    func loadData() {
        let walk = Walk(name:"Fontinahs Walk", context: sharedContext)
        
        //let places = GeoDataManager.sharedInstance.getPlaces()
        
        //walk.places = NSSet(array: places)
        GeoDataManager.sharedInstance.loadData(walk)
        ContentManager.sharedInstance.loadData(walk)
        
        CoreDataStackManager.sharedInstance.saveContext()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    func getWalks()-> [Walk] {
        let fetchRequest = NSFetchRequest(entityName: "Walk")
        do {
            var walks = try sharedContext.executeFetchRequest(fetchRequest) as! [Walk]
            if walks.isEmpty {
                loadData()
            }
            walks = try sharedContext.executeFetchRequest(fetchRequest) as! [Walk]
            return walks
        } catch {
            fatalError("Failed to fetch Walks")
        }
        return [Walk]()
    }
    
    func  getWalk(id:String) -> Walk? {
        let fetchRequest = NSFetchRequest(entityName: "Walk")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        var walks=[Walk]()
        do {
             walks = try sharedContext.executeFetchRequest(fetchRequest) as! [Walk]
            
        } catch {
            fatalError("Failed to fetch Walks")
        }
        
        return walks.first
        
    }
    
    func getCurrentWalk() -> Walk {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        let walkId = standardDefaults.valueForKey("CurrentWalkId") as? String
        return getWalk(walkId!)!
    }
}