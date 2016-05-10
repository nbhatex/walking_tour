//
//  FaqManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 06/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class FaqManager {
    static let sharedInstance = FaqManager()
    var faqs:[Faq]
    private init() {
        let dataAsset = NSDataAsset(name: "faq_json")
        faqs = [Faq]()
        do {
            if let data = dataAsset?.data {
                let parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let faqJsons = parsedData as? [[String:AnyObject]] {
                    for dictionary in faqJsons {
                        let faq = Faq(dictionary: dictionary)
                        faqs.append(faq)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}