//
//  Weather.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 16/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation

struct Forecast {
    var dateString:String
    var maxTemp:Float
    var minTemp:Float
    var unit:String
    var message:String
    
    init(dayForecast:[String:AnyObject]){
        let timeInSeconds = dayForecast["dt"] as? Double
        let date = NSDate(timeIntervalSince1970: timeInSeconds!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd" //Set date style
        dateFormatter.timeZone = NSTimeZone()
        dateString = dateFormatter.stringFromDate(date)
        
        maxTemp = 0.0
        minTemp = 0.0
        if let temparatures = dayForecast["temp"] as? [String:AnyObject] {
            maxTemp = (temparatures["max"] as? Float)!
            minTemp = (temparatures["min"] as? Float)!
        }
        message = "Not known"
        for info in (dayForecast["weather"] as? [[String:AnyObject]])! {
            message = (info["description"] as? String)!
        }
        unit = "C"
    }
    
    var formattedText:String {
        return "\(dateString)      \(maxTemp) \(unit)   \(minTemp) \(unit)      \(message)"
    }
}