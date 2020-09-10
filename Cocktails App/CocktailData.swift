//
//  CocktailData.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 09.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import Foundation

struct Drinks {
    
    //var drinkName = String()
    var drinks = [CocktailData]()
}

struct CocktailData {
    
    var title: String
    var imageURL: String
    
    init(title: String, imageURL: String) {
        self.title = title
        self.imageURL = imageURL
    }
}
