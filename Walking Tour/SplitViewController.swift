//
//  SplieViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 05/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    var assignedDisplayMode:UISplitViewControllerDisplayMode!
    
    var contentManager: ContentManager {
        return ContentManager.sharedInstance
    }
    var placeId:Int! {
        didSet {
            let placeViewController = self.viewControllers.last as! PlaceViewController
            placeViewController.placeSelected(contentManager.getContent(placeId))
        }
    }
    
    override func viewDidLoad() {
        let placeViewController = self.viewControllers.last as! PlaceViewController
        
        if let id = placeId {
            placeViewController.content = contentManager.getContent(id)
        } else {
            placeViewController.content = contentManager.getContents().first
        }
        
        
        let leftNavController = self.viewControllers.first as! UINavigationController
        let placeListController = leftNavController.topViewController as! PlaceListController
        placeListController.delegate = placeViewController
        self.preferredDisplayMode = .AllVisible
        self.delegate = self
    }
    
    // Decide to show detail view controller or primary view controller
    // When shown from the callout on map detail is shown
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        if let givenDisplayMode = assignedDisplayMode {
            if givenDisplayMode == .PrimaryHidden {
                return false
            }
        }
        return true
    }
}