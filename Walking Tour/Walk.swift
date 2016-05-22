//
//  Walks.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 21/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
import CoreData


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
}
