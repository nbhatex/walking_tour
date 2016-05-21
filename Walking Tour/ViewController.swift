//
//  ViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 01/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartWalk" {
            print("Start Walking")
            if let tabBarController = segue.destinationViewController as? UITabBarController {
                if let placeSelectionDelegate = tabBarController.viewControllers![0] as? PlaceSelectionDelegate {
                    LocationManager.sharedInstance.placeSelectionDelegate = placeSelectionDelegate
                }
            }
            
        }
    }
}

