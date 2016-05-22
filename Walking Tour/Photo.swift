//
//  Photo.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 08/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import CoreData
class Photo:NSManagedObject {
    @NSManaged var name:String
    @NSManaged var title:String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:String], context:NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
        super.init(entity: entity!,insertIntoManagedObjectContext:context)
        
        if let nameFromJson = dictionary["resourceId"]  {
            name = nameFromJson
        } else {
            name = ""
        }
        
        if let titleFromJson = dictionary["title"] {
            title = titleFromJson
        } else {
            title = "Image"
        }
    }
}