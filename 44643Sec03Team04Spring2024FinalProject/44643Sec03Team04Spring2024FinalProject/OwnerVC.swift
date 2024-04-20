//
//  OwnerVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/12/24.
//

import UIKit

class OwnerVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var userEmail: String?
    
    @IBOutlet weak var categoryTV: UITableView!
    
    let rowTexts = ["🚜         Tractors", "🚜🌾    Harvestors", "🌱🚜    Fertilizer Spreader", "🚜🔧    Others"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("userEmail:\(String(describing: userEmail))")
        return rowTexts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath)
        cell.textLabel?.text = rowTexts[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        categoryTV.dataSource = self
        categoryTV.delegate = self
        categoryTV.register(UITableViewCell.self, forCellReuseIdentifier: "machineCell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = rowTexts[indexPath.row]
        performSegue(withIdentifier: "addPage", sender: selectedCategory)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPage", let selectedCategory = sender as? String {
                    if let postVC = segue.destination as? PostVC {
                        postVC.categoryType = selectedCategory
                    }
        }
    }
}
