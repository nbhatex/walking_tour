//
//  Walks+CoreDataProperties.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 21/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Walk {

    @NSManaged var id:String?
    @NSManaged var name: String?
    @NSManaged var places: NSOrderedSet?
    @NSManaged var contents:NSOrderedSet?
    


}
