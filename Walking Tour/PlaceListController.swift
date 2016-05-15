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
    
    var sectioHeaderView:UIView!
    
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
        if splitViewController?.collapsed == true  {
            return sectioHeaderView
        } else {
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if splitViewController?.collapsed == true  {
            sectioHeaderView.sizeToFit()
            return sectioHeaderView.frame.height
        } else {
            return 0
        }
    }
    
    //MARK: UI Helper methods
    
    func initSectionHeader()  {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "post_office")
        imageView.contentMode = .ScaleAspectFill
        imageView.sizeToFit()
        let imageHeight = imageView.frame.height
        
        let imageLabel = UILabel()
        imageLabel.text = "Post Office"
        imageLabel.textAlignment = .Center
        imageLabel.font = UIFont(name: "Helvetica", size: 13)
        imageLabel.sizeToFit()
        imageLabel.frame = CGRect(x: 0, y: imageHeight, width: view.frame.width, height: 20)
        let labelHeight = imageLabel.frame.height
        
        let headerHeight = imageHeight + labelHeight
        
    
        
        sectioHeaderView = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        
        sectioHeaderView.addSubview(imageView)
        sectioHeaderView.addSubview(imageLabel)
    }
}