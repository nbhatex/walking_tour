//
//  FaqsTableviewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 06/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class FaqsTableViewController : UITableViewController {
    
    var sectionCounts:[Int]!
    
    var sectionData = [Int:Any]()
    
    var faqsManager:FaqManager {
        return FaqManager.sharedInstance
    }
    var currentSelected:NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCounts = [Int](count: faqsManager.faqs.count, repeatedValue: 0)
    }

    // MARK: Tableview delegate methods
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return faqsManager.faqs.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionCounts[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FaqCell")
        let faq = faqsManager.faqs[indexPath.section]
        switch faq.type {
        case FaqType.Weather :
            cell?.textLabel?.text = "Weather Forecast"
            if let forecasts = sectionData[indexPath.section] as? [Forecast]{
                let forecast = forecasts[indexPath.row]
                cell?.textLabel?.text = forecast.formattedText
                
            }
            
        default:
            let text = faqsManager.faqs[indexPath.section].description
            let data = text!.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let formattedText = try NSAttributedString(data:data! , options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                cell?.textLabel?.attributedText = formattedText
                cell?.textLabel?.font = UIFont(name: "Helvetica", size: 15)
                cell?.textLabel?.textAlignment = .Justified
            } catch {
                print(error)
            }
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.lineBreakMode = .ByWordWrapping
        }
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView();
        
        let labelWidth = view.frame.width * 0.8
        let label = UILabel(frame:CGRectMake(20,5,labelWidth,25))
        label.text = faqsManager.faqs[section].title
        label.textColor = UIColor(colorLiteralRed: 239/256, green: 155/256, blue: 20/256, alpha: 1)
        
        sectionHeader.addSubview(label)
        
        let button = UIButton(type: .DetailDisclosure)
        button.frame = CGRectMake(labelWidth,5 , view.frame.width * 0.2, 25)
        button.addTarget(self, action: #selector(FaqsTableViewController.onClickOfSectionInfo(_:)), forControlEvents: .TouchUpInside)
        button.tag = section
        sectionHeader.addSubview(button)
        
        return sectionHeader
    }
    
    func onClickOfSectionInfo(sender:UIButton) {
        print("Info clicked \(sender.tag)")
        
        let section = sender.tag

        let faq = faqsManager.faqs[section]
        switch faq.type {
        case FaqType.QAndA :
            tableView.beginUpdates()
            if sectionCounts[section] == 0  {
                sectionCounts[section] = sectionCounts[section] + 1
                tableView.insertRowsAtIndexPaths([NSIndexPath(forItem:0, inSection: section)], withRowAnimation: UITableViewRowAnimation(rawValue: 0)! )
            
            } else {
                sectionCounts[section] = sectionCounts[section] - 1
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem:0, inSection: section)], withRowAnimation: UITableViewRowAnimation(rawValue: 0)!)
            }
            tableView.endUpdates()
        case FaqType.Weather:
            if sectionCounts[section] == 0  {
                if let forecasts = sectionData[section] as? [Forecast]{
                    sectionCounts[section] = forecasts.count
                    tableView.beginUpdates()
                    var indexPaths = [NSIndexPath]()
                    for index in 0..<forecasts.count {
                        indexPaths.append(NSIndexPath(forItem:index, inSection: section))
                    }
                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation(rawValue: 0)! )
                    tableView.endUpdates()
                } else {
                    WeatherManager.sharedInstance.getWeatherForNext3days(faq.cityId!,successHandler: {forecasts in
                        self.sectionCounts[section] = forecasts.count
                        self.sectionData[section] = forecasts
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.beginUpdates()
                            var indexPaths = [NSIndexPath]()
                            for index in 0..<forecasts.count {
                                indexPaths.append(NSIndexPath(forItem:index, inSection: section))
                            }
                            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation(rawValue: 0)! )
                            self.tableView.endUpdates()
                
                        })
                },failureHandler: { message in
                    print(message)
                    })
                }
            } else {
                sectionCounts[section] = 0
                if let forecasts = sectionData[section] as? [Forecast]{
                    self.tableView.beginUpdates()
                    var indexPaths = [NSIndexPath]()
                    for index in 0..<forecasts.count {
                        indexPaths.append(NSIndexPath(forItem:index, inSection: section))
                    }
                    self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation(rawValue: 0)! )
                    self.tableView.endUpdates()
                }
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.detailTextLabel?.sizeToFit()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let faq = faqsManager.faqs[indexPath.section]
        
        switch faq.type {
        case FaqType.QAndA:
            if sectionCounts[indexPath.section] == 0  {
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            } else {
                let font = UIFont(name: "Helvetica", size: 15)
                let height = heightForView(faqsManager.faqs[indexPath.section].description!, font: font!, width: self.view.frame.width)
                return height
            }
        case FaqType.Weather:
            return 20
        }
        
        
    }
    
    //MARK: UI Helper methods
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}