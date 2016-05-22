//
//  PlaceListCell.swift
//  Walking Tour
//
//  Created by Narasimha Bhat on 08/05/16.
//  Copyright © 2016 Narasimha Bhat. All rights reserved.
//

import UIKit

class PlaceListCell: UITableViewCell {
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func  setTitle (title:String) {
        titleLabel.text = title
        headLabel.text = String(title.characters.first!)
        headLabel.backgroundColor = Colors.getColor(title)
        headLabel.clipsToBounds = true
    }
    
}