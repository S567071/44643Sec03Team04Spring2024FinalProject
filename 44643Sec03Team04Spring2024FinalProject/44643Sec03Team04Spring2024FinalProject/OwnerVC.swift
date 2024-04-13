//
//  OwnerVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/12/24.
//

import UIKit

class OwnerVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTV: UITableView!
    
    let rowTexts = ["🚜         Tractors", "🚜🌾    Harvestors", "🌱🚜    Fertilizer Spreader", "🚜🔧    Others"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTexts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath)
                // Configure your cell here
        cell.textLabel?.text = rowTexts[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryTV.dataSource = self
        categoryTV.delegate = self
                
                // Register cell
        categoryTV.register(UITableViewCell.self, forCellReuseIdentifier: "machineCell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "addPage", sender: self)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
