//
//  FilterCell.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 09.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        //checkmarkButton.setImage(.checkmark, for: .normal)
//    }
    
    func cellUpdate(title: String, selectedCategories: [String]) {
        
        categorieLabel.text = title
        
//        for category in selectedCategories {
//
//            if categorieLabel.text == category {
//                checkmarkButton.setTitle("selected", for: .normal)
//            }
//        }
    }
}
