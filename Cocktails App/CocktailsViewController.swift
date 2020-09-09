//
//  ViewController.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 08.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CocktailsViewController: UIViewController {
    
    var cocktailsCount = Int()
    var drinks = [String]()
    
    var titlesArray = [String]()
    var imageURLArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCocktailsData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CocktailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("drinks.count->\(drinks.count)")
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell") as? CocktailCell   else {
            return UITableViewCell()
        }
        
        var titles = String()
        var imagesURL: URL?
        
        if titlesArray.count > 0 {
            titles = titlesArray[indexPath.row]
        } else {
            titles = ""
        }
        
        if imageURLArray.count > 0 {
            imagesURL = URL(string: String(imageURLArray[indexPath.row]))!
        } else {
            imagesURL = URL(string: "https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png")
        }
        
        cell.configureCell(cocktailTitle: titles, cocktailImage: imagesURL!)
        
        return cell
    }
}

extension CocktailsViewController {
    
    func getCocktailsData() {
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink")
        
        request.responseJSON { (json) in
            print(json)
            if let data = json.data {
                if let json = try? JSON(data: data) {
                    for item in json["drinks"].arrayValue {
                        
                        self.titlesArray.append(item["strDrink"].stringValue)
                        self.imageURLArray.append(item["strDrinkThumb"].stringValue)
                        
                        self.cocktailsCount = json["drinks"].count
                        self.drinks.append(item["strDrink"].stringValue)
                        print("drinks.count2 \(self.drinks.count)")

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
