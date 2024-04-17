//
//  UserAccount.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/17/24.
//

import UIKit

class UserAccount: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameLBL: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        let userViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as? UIViewController
        self.view.window?.rootViewController = userViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBOutlet weak var dataTV: UITableView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
