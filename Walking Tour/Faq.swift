//
//  Faq.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 06/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation

enum FaqType:String {
    case QAndA = "QAndA"
    case Weather = "Weather"
}

class Faq {

    var title:String
    var type:FaqType
    var description:String?
    var cityId:String?
    
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
        
        if let typeFromJson = dictionary["type"] as? String {
            type = FaqType(rawValue: typeFromJson)!
        } else {
            type = FaqType.QAndA
        }
        
        if let cityIdFromJson = dictionary["city_id"] as? String {
            cityId = cityIdFromJson
        } else {
            cityId = ""
        }
    }
}