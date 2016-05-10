//
//  ContentManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class ContentManager {
    static let sharedInstance = ContentManager()
    var contents:[Content]
    private var contentsForSearch:[Int:Content]
    private init() {
        let dataAsset = NSDataAsset(name: "text_json")
        contents = [Content]()
        contentsForSearch = [Int:Content]()
        do {
            if let data = dataAsset?.data {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let contentJsons = parsedData as? [[String:AnyObject]] {
                    for dictionary in contentJsons {
                        let content = Content(dictionary: dictionary)
                        contents.append(content)
                        contentsForSearch[content.id] = content
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getContents() -> [Content] {
        return contents
    }
    
    func getContent(id:Int) -> Content! {
        return contentsForSearch[id]
    }
}