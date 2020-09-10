//
//  FilterViewController.swift
//  Cocktails App
//
//  Created by Nikita Kalyuzhnyy on 09.09.2020.
//  Copyright © 2020 Nikita Kalyuzhnyy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FilterViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var categories = [String]()
    var selectedCategories = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if defaults.object(forKey: "selectedCategories") != nil {
            selectedCategories = defaults.object(forKey: "selectedCategories") as? [String] ?? [String]()
        }
        
        getFiltersData()
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedCategories.contains(categories[indexPath.row]) {
            if let index = selectedCategories.firstIndex(of: categories[indexPath.row]) {
                selectedCategories.remove(at: index)
            }
        } else {
            selectedCategories.append(categories[indexPath.row])
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        defaults.setValue(selectedCategories, forKeyPath: "selectedCategories")
        defaults.synchronize()
        
        print(selectedCategories)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Filter Cell") as? FilterCell else { return UITableViewCell()}
        
        if selectedCategories.contains(categories[indexPath.row]) {
            cell.checkmarkButton.setTitle("+", for: .normal)
        } else {
            cell.checkmarkButton.setTitle("-", for: .normal)
        }
        
        cell.cellUpdate(title: categories[indexPath.row], selectedCategories: selectedCategories)
        
        return cell
    }
    
    
}

extension FilterViewController {
    
    func getFiltersData() {
        
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")
        
        request.responseJSON { (json) in
            if let data = json.data {
                if let json = try? JSON(data: data) {
                    for item in json["drinks"].arrayValue {
                        
                        self.categories.append(item["strCategory"].stringValue)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
