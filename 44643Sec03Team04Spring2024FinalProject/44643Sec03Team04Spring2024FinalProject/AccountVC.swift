//
//  AccountVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/15/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var userData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        dataTV.dataSource = self
        dataTV.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameLBL: UILabel!
    
    @IBOutlet weak var emailLBL: UILabel!
    
    @IBOutlet weak var phoneLBL: UILabel!
    
    @IBOutlet weak var dataTV: UITableView!
    
    
    @IBAction func logout(_ sender: UIButton) {
    
        let userViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as? UIViewController
        self.view.window?.rootViewController = userViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func fetchUserData() {
       
        Firestore.firestore().collection("User").document(AppDelegate.username).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                self.userData = document.data()
                self.updateUI()
                self.dataTV.reloadData()
                print(userData!)
            } else {
                print("User document does not exist")
            }
        }
    }
    
    func updateUI() {
        guard let userData = self.userData else {
            print("User data is nil.")
            return
        }
        if let firstName = userData["FirstName"] as? String, let lastName = userData["LastName"] as? String {
            self.usernameLBL.text = "Hello!...\(firstName) \(lastName)"
        } else {
            print("First name or last name is nil.")
        }

//        if let email = userData["Email"] as? String {
//            self.emailLBL.text = "\(email)"
//        } else {
//            print("Email is nil.")
//        }
//
//        if let phoneNumber = userData["PhoneNumber"] as? Int {
//            self.phoneLBL.text = "\(phoneNumber)"
//        } else {
//            print("Phone number is nil.")
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTV.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        guard let userData = self.userData else {
               return cell
           }
           
           if let header = userData["Header"] as? String, let price = userData["Price"] as? Double {
               cell.textLabel?.text = header
               cell.detailTextLabel?.text = "\(price)"
           }
           
           return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let segueAction = UIContextualAction(style: .normal, title: "Update") { [weak self] (action, view, completionHandler) in
            self?.performSegue(withIdentifier: "showModify", sender: indexPath)
            completionHandler(true)
        }
        segueAction.backgroundColor = .green

        let swipeConfig = UISwipeActionsConfiguration(actions: [segueAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
}
