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
    
    let defaults = UserDefaults()
    
    var selectedCategories = [String]()
    
    var orderedDrinks = [String:[CocktailData]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
        selectedCategories = defaults.value(forKey: "selectedCategories") as? [String] ?? [String]()
        
        for category in selectedCategories {
            getCocktailsData(parameter: category)
        }
        
        debugPrint("**********\(selectedCategories)")
    }
}

extension CocktailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return Array(orderedDrinks.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Array(orderedDrinks.keys).count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Array(orderedDrinks.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell") as? CocktailCell else { return UITableViewCell() }
        
        var titles = String()
        var imagesURL: URL?
        
        if Array(orderedDrinks.values)[indexPath.section].count > 0 {
            titles = Array(Array(orderedDrinks.values)[indexPath.section])[indexPath.row].title
            imagesURL = URL(string: Array(Array(orderedDrinks.values)[indexPath.section])[indexPath.row].imageURL)
        } else {
            titles = ""
            imagesURL = URL(string: "https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png")
        }
        
        cell.configureCell(cocktailTitle: titles, cocktailImage: imagesURL!)
        
        return cell
    }
}

extension CocktailsViewController {
    
    func getCocktailsData(parameter: String) {
        
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(parameter)")
        
        request.responseJSON { (json) in
            if let data = json.data {
                if let json = try? JSON(data: data) {
                    
                    for item in json["drinks"].arrayValue {
                        
                        let drinkData = CocktailData(title: item["strDrink"].stringValue, imageURL: item["strDrinkThumb"].stringValue)
                        
                        self.orderedDrinks.append(element: drinkData, toValueOfKey: parameter)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    print("********\(self.orderedDrinks)")
                }
            }
        }
    }
}

extension Dictionary where Value: RangeReplaceableCollection {
    
    public mutating func append(element: Value.Iterator.Element, toValueOfKey key: Key) -> Value? {
        var value: Value = self[key] ?? Value()
        value.append(element)
        self[key] = value
        return value
    }
}
