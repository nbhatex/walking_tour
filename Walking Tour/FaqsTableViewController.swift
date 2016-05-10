//
//  FaqsTableviewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 06/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class FaqsTableViewController : UITableViewController {
    var faqsManager:FaqManager {
        return FaqManager.sharedInstance
    }
    var currentSelected:NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController)
    }

    // MARK: Tableview delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqsManager.faqs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FaqCell")
        cell?.textLabel?.text = faqsManager.faqs[indexPath.row].title
        cell?.detailTextLabel?.text = faqsManager.faqs[indexPath.row].description
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.lineBreakMode = .ByWordWrapping
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.detailTextLabel?.sizeToFit()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let font = UIFont(name: "Helvetica", size: 15)
        let height = heightForView(faqsManager.faqs[indexPath.row].description, font: font!, width: self.view.frame.width)
        return height
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