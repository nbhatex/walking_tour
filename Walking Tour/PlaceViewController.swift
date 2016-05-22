//
//  PlaceViewController.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 05/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class PlaceViewController:UIViewController, PlaceSelectionDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var descriptionText: UITextView!
    
    var content:Content!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let placeContent = content {
            placeSelected(placeContent)
        } else {
            if let firstContent = ContentManager.sharedInstance.getContents().first {
                placeSelected(firstContent)
            }
        }
        descriptionText.textContainerInset = UIEdgeInsetsMake(0, 20, 20, 20)
        imageScrollView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageScrollView.pagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func placeSelected(newContent: Content) {
        descriptionText.text = newContent.explaination
        pageControl.hidden = true
        imageScrollView.subviews.map { $0.removeFromSuperview() }
        if newContent.photos.count == 0 {
            scrollViewHeight.constant = 0
            return
        }
        let imageWidth = view.frame.width
        let imageHeight = view.frame.height * 0.4
        var imageNum = CGFloat(0.0);
        let contentWidth = CGFloat(newContent.photos.count) * imageWidth
        imageScrollView.contentSize = CGSize(width: contentWidth , height: imageHeight+20)
        for photo in newContent.photos {
            let offset = imageNum * imageWidth
            
            let imageView = UIImageView(frame:CGRectMake(offset, 0, imageWidth, imageHeight))
            imageView.image=UIImage(named: photo.name)
            imageView.contentMode = .ScaleAspectFit
            imageScrollView.addSubview(imageView)
            
            let imageLabel = UILabel(frame:CGRectMake(offset, imageHeight , imageWidth, 20))
            imageLabel.text = photo.title
            imageLabel.textAlignment = .Center
            imageLabel.font = UIFont(name: "Helvetica", size: 13)
            imageScrollView.addSubview(imageLabel)
            
            imageNum = imageNum + 1.0
        }
        if newContent.photos.count > 1 {
            pageControl.pageIndicatorTintColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 1)
            pageControl.currentPageIndicatorTintColor = UIColor(colorLiteralRed: 0, green: 1, blue: 0, alpha: 1)
            pageControl.numberOfPages = newContent.photos.count
            pageControl.autoresizingMask = .FlexibleLeftMargin
            pageControl.currentPage = 0
            pageControl.hidden = false
        }
        imageScrollView.sizeToFit()
        
        
        scrollViewHeight.constant = imageHeight+20
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if pageControl != nil {
            let pageNum = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageNum)
        }
    }
}
