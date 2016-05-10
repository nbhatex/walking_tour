//
//  PlaceViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 05/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class PlaceViewController:UIViewController, PlaceSelectionDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var content:Content!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let placeContent = content {
            placeSelected(placeContent)
        } else {
            if let firstContent = ContentManager.sharedInstance.contents.first {
                placeSelected(firstContent)
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageScrollView.pagingEnabled = true
    }
    
    func placeSelected(newContent: Content) {
        descriptionLabel.text = newContent.description
        imageScrollView.subviews.map { $0.removeFromSuperview() }
        if newContent.photos.isEmpty {
            scrollViewHeight.constant = 0
            return
        }
        let imageWidth = view.frame.width
        let imageHeight = view.frame.height * 0.4
        var imageNum = CGFloat(0.0);
        for photo in newContent.photos {
            let offset = imageNum * imageWidth
            let imageContainerView = UIView()
            
            let imageView = UIImageView(frame: CGRectMake(offset, 0, imageWidth, imageHeight - 20))
            imageView.image=UIImage(named: photo.name)
            imageView.contentMode = .ScaleAspectFit
            imageContainerView.addSubview(imageView)
            
            let imageLabel = UILabel(frame:CGRectMake(offset, imageHeight - 20 , imageWidth, 20))
            imageLabel.text = photo.title
            imageLabel.textAlignment = .Center
            imageLabel.font = UIFont(name: "Helvetica", size: 13)
            imageContainerView.addSubview(imageLabel)
            
            imageScrollView.addSubview(imageContainerView)
            imageNum = imageNum + 1.0
        }
        imageScrollView.contentSize = CGSize(width: imageNum * imageWidth, height: imageHeight)
        scrollViewHeight.constant = imageHeight
    }
}
