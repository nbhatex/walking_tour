//
//  Faq.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 06/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation

class Faq {

    var title:String
    var description:String
    
    init(dictionary:[String:AnyObject]){
        
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
    }
}