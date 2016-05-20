//
//  WaetherManager.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 15/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import Foundation


let API_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
let APP_ID = "69607c360e06568fcab58f12b5799c64"


class WeatherManager {
    
    static let sharedInstance = WeatherManager()
    
    let session = NSURLSession.sharedSession()
    
    private init() {}
    
    func getWeatherForNext3days(cityId:String,successHandler:([Forecast])->(),failureHandler:(message:String)->()) {
        let methodParameters:[String:String] = [
            "id" : "\(cityId)",
            "mode" : "json",
            "appid" : APP_ID,
            "cnt" : "3",
            "units" : "metric"
        ]
        
        let requestUrl = "\(API_URL)/\(escapedParameters(methodParameters))"
        let request = NSMutableURLRequest(URL: NSURL(string:requestUrl)!)
        
        let task = session.dataTaskWithRequest(request,completionHandler: {(data,response,error) in
            let errorMessage = self.checkForError(data, response: response, error: error)
            
            guard( errorMessage == nil) else {
                failureHandler(message: errorMessage!)
                return
            }
            
            var parsedData:[String:AnyObject]
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String : AnyObject]
                var forecasts = [Forecast]()
                for dayForecast in (parsedData["list"] as? [[String:AnyObject]])!{
                    let weather = Forecast(dayForecast: dayForecast)
                    forecasts.append(weather)
                }
                successHandler(forecasts)
            } catch {
                
            }
        })
        
        task.resume()
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func checkForError(data:NSData?,response:NSURLResponse?,error:NSError?)->String? {
        
        guard(error == nil) else {
            return (error?.localizedDescription)!
        }
        
        guard let statusCode = ( response as? NSHTTPURLResponse )?.statusCode where statusCode >= 200 && statusCode < 300 else {
            let statusCode = (response as? NSHTTPURLResponse )?.statusCode
            return "\(statusCode) - Error returned for request"
        }
        return nil
    }
}