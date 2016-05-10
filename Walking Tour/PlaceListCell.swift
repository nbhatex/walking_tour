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
    
    let colors = [UIColor(colorLiteralRed: 140/255, green: 196/255, blue: 82/255, alpha: 1),
                         UIColor(colorLiteralRed: 243/255, green: 180/255, blue: 30/255, alpha: 1),
                         UIColor(colorLiteralRed: 225/255, green: 55/255, blue: 48/255, alpha: 1),
                         UIColor(colorLiteralRed: 105/255, green: 106/255, blue: 106/255, alpha: 1),
                         UIColor(colorLiteralRed: 64/255, green: 89/255, blue: 37/255, alpha: 1),
                         UIColor(colorLiteralRed: 224/255, green: 107/255, blue: 29/255, alpha: 1),
                         UIColor(colorLiteralRed: 59/255, green: 110/255, blue: 184/255, alpha: 1),
                         UIColor(colorLiteralRed: 242/255, green: 160/255, blue: 22/255, alpha: 1),
                         UIColor(colorLiteralRed: 252/255, green: 195/255, blue: 14/255, alpha: 1),
                         UIColor(colorLiteralRed: 251/255, green: 146/255, blue: 93/255, alpha: 1),
                         UIColor(colorLiteralRed: 157/255, green: 243/255, blue: 251/255, alpha: 1)]
    
    func  setTitle (title:String) {
        titleLabel.text = title
        headLabel.text = String(title.characters.first!)
        let sclars = title.unicodeScalars
        let alphabetIdx = sclars[sclars.startIndex].value - 65
        headLabel.backgroundColor = colors[Int(alphabetIdx % 11)]
        headLabel.clipsToBounds = true
    }
    
}