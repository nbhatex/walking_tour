//
//  ViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 01/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController {

    @IBOutlet weak var currentWalk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let walks = WalkManager.sharedInstance.getWalks()
        if !walks.isEmpty {
            let walk = walks.first!
            currentWalk.setTitle(walk.name, forState: .Normal)
            let standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setObject(walk.id, forKey: "CurrentWalkId")
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartWalk" {
            print("Start Walking")
            if let tabBarController = segue.destinationViewController as? UITabBarController {
                if let placeSelectionDelegate = tabBarController.viewControllers![0] as? PlaceSelectionDelegate {
                    LocationManager.sharedInstance.placeSelectionDelegate = placeSelectionDelegate
                }
            }
            
        } else {
            LocationManager.sharedInstance.clearLocationData()
        }
    }

}

