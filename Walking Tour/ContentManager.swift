//
//  ContentManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import CoreData

class ContentManager {
    static let sharedInstance = ContentManager()
    private init() { }
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    func loadData(walk:Walk) {
        let dataAsset = NSDataAsset(name: "text_json")
        var contents = [Content]()
        do {
            if let data = dataAsset?.data {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let contentJsons = parsedData as? [[String:AnyObject]] {
                    for dictionary in contentJsons {
                        let content = Content(dictionary: dictionary,context: sharedContext)
                        contents.append(content)
                    }
                }
                walk.contents = NSOrderedSet(array: contents)
            }
        } catch {
            print(error)
        }
    }
    
    func getContent(id:Int) -> Content! {
        let fetchRequest = NSFetchRequest(entityName: "Content")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let contents = try sharedContext.executeFetchRequest(fetchRequest) as? [Content]
            return contents?.first
        } catch {
            
        }
        return nil
    }
}