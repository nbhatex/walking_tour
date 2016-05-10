//
//  Content.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation

class Content {
    var id:Int
    var title:String
    var description:String
    var photos:[Photo]
    
    init(dictionary:[String:AnyObject]){
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
            description = descriptionFromJson
        } else {
            description = ""
        }
        
        photos=[Photo]()
        if let photosFromJson = dictionary["images"] as? [[String:String]] {
            for photoFromJson in photosFromJson {
                photos.append(Photo(dictionary: photoFromJson))
            }
        }
    }
}