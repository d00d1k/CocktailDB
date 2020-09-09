//
//  CocktailsList.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 08.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import Foundation

struct Cocktails: Decodable {
    
    var drinks: [Cocktail]
}

struct Cocktail: Decodable {
    
    var idDrink: Int?
    var strDrink: String?
    var strDrinkThumb: String?
}
