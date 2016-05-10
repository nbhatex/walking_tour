//
//  Photo.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 08/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation
class Photo {
    var name:String
    var title:String
    
    init(dictionary:[String:String]){
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