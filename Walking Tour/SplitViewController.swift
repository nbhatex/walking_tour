//
//  SplieViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 05/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        let placeViewController = self.viewControllers.last as! PlaceViewController
        
        placeViewController.content = ContentManager.sharedInstance.contents.first
        
        let leftNavController = self.viewControllers.first as! UINavigationController
        let placeListController = leftNavController.topViewController as! PlaceListController
        placeListController.delegate = placeViewController
        self.preferredDisplayMode = .AllVisible
        self.delegate = self
    }
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
}