//
//  Content.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import CoreData

class Content:NSManagedObject {
    
    @NSManaged var id:NSNumber
    @NSManaged var seqno:NSNumber
    @NSManaged var title:String
    @NSManaged var explaination:String
    @NSManaged var photos:NSSet
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName("Content", inManagedObjectContext: context)
        super.init(entity: entity!,insertIntoManagedObjectContext:context)
        
        if let idFromJson = dictionary["id"] as? Int {
            id = idFromJson
        } else {
            id = 0
        }
        
        if let titleFromJson = dictionary["title"] as? String {
            title = titleFromJson
        } else {
            title = ""
        }
        
        if let descriptionFromJson = dictionary["description"] as? String {
            explaination = descriptionFromJson
        } else {
            explaination = ""
        }
        
        if let seqnoFromJson = dictionary["poi_id"] as? Int {
            seqno = seqnoFromJson
        } else {
            seqno = 1
        }
        
        var photos=[Photo]()
        if let photosFromJson = dictionary["images"] as? [[String:String]] {
            for photoFromJson in photosFromJson {
                photos.append(Photo(dictionary: photoFromJson,context: context))
            }
        }
        self.photos = NSSet(array: photos)
    }
}