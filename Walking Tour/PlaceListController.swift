//
//  PlaceListController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 04/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

protocol PlaceSelectionDelegate: class  {
    func placeSelected(newContent: Content)
}

class PlaceListController: UITableViewController {
    
    weak var delegate:PlaceSelectionDelegate?
    
    var sectionHeaderHeight = CGFloat(100)
    
    var sectioHeaderView:UIImageView!
    
    var contentManager:ContentManager {
        return ContentManager.sharedInstance
    }
    override func viewDidLoad() {
        initSectionHeader()
    }
    
    //MARK: table delegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
            return contentManager.contents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PlaceListCell") as? PlaceListCell
        if cell == nil {
            cell = PlaceListCell()
        }
        cell!.setTitle(contentManager.contents[indexPath.row].title)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let detailDelegate = delegate {
            detailDelegate.placeSelected(contentManager.contents[indexPath.row])
        }
        
        if let detailViewController = self.delegate as? PlaceViewController {
            if splitViewController?.collapsed == true  {
                splitViewController?.navigationController?.pushViewController(detailViewController, animated: true)
            } else {
                splitViewController?.showDetailViewController(detailViewController, sender: nil)
            }            
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectioHeaderView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectioHeaderView.sizeToFit()
        return sectioHeaderView.frame.height
    }
    
    func initSectionHeader()  {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "post_office")
        imageView.contentMode = .ScaleAspectFill
        sectioHeaderView = imageView
    }
}