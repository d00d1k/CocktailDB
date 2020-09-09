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
    
    var filterVC = FilterViewController()
    var selectedCategories = [String]()
    
    var orderedDrinks = [String:[[CocktailData]]]()
    
    var drinks = [String]()
    
    var tdrinkss = [Drinks]()
    
    var titlesArray = [String]()
    var imageURLArray = [String]()
     
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        drinks.removeAll()
        
        selectedCategories = defaults.value(forKey: "selectedCategories") as? [String] ?? [String]()
        
        for category in selectedCategories {
            getCocktailsData(parameter: category)
        }
        
        debugPrint("**********\(selectedCategories)")
    }
}

extension CocktailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if drinks.count == 0 {
            return ""
        } else {
            return selectedCategories[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if drinks.count == 0 {
            return 0
        } else {
            return selectedCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //print("drinks.count->\(drinks.count)")
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell") as? CocktailCell else {
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
    
    func getCocktailsData(parameter: String) {
        
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(parameter)")
        
        request.responseJSON { (json) in
            //print(json)
            if let data = json.data {
                if let json = try? JSON(data: data) {
                    
                    for item in json["drinks"].arrayValue {
                        
                        
//                        var drinkss = CocktailData(title: item["strDrink"].stringValue, imageURL: item["strDrinkThumb"].stringValue)
                        
                        
                        
                        //self.tdrinkss.append([drinkss])
                        
                        //self.orderedDrinks.updateValue([[drinkss]], forKey: parameter)
                        
                        //self.orderedDrinks.values
                        //([drinkss], forKey: parameter)
                        //self.drinkss.removeAll()
                        //print("kekeekek\(self.orderedDrinks)")
                        
//                        self.titlesArray.append(item["strDrink"].stringValue)
//                        self.imageURLArray.append(item["strDrinkThumb"].stringValue)
                        
                        self.titlesArray.insert(item["strDrink"].stringValue, at: self.titlesArray.endIndex)
                        self.imageURLArray.insert(item["strDrinkThumb"].stringValue, at: self.imageURLArray.endIndex)
                        
                        self.drinks.append(item["strDrink"].stringValue)
                        //print("drinks.count2 \(self.drinks.count)")
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension UIViewController
{
    func setLeftAlignedNavigationItemTitle(text: String,
                                           color: UIColor,
                                           margin left: CGFloat)
    {
        let titleLabel = UILabel()
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.titleView = titleLabel
        
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        
        // NOTE: This always seems to be 0. Huh??
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + left),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
}
