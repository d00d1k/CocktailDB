//
//  CocktailCell.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 09.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import Foundation
import UIKit

class CocktailCell: UITableViewCell {
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailImage: UIImageView!
    
    func configureCell(cocktailTitle: String, cocktailImage: URL) {
        self.cocktailNameLabel.text = cocktailTitle
        
        DispatchQueue.global(qos: .userInitiated).async {

            do {
                let data = try Data(contentsOf: (cocktailImage))
                let myimage = UIImage(data: data)
                DispatchQueue.main.sync {
                    self.cocktailImage.image = myimage
                }
            } catch {
                debugPrint("img error")
            }
        }
    }
    
}
