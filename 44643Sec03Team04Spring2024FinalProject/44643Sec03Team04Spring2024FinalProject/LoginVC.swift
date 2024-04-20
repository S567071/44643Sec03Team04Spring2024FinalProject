//
//  LoginVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 2/23/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

class LoginVC: UIViewController {

    
    @IBOutlet weak var loginID: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var messageLBL: UILabel!
    
    let options = ["Owner", "User"]
    
    var selectedOption : String = "Owner"
    var username = ""
    
    @IBAction func register(_ sender: UIButton) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "RegisterationVC") as! RegisterationVC
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1103)
        if loginID.text == "" {
            
            messageLBL.text = "Please enter Username!."
        }else if password.text == "" {
            
            messageLBL.text = "Please enter Password!"
        }else {
            self.username = self.loginID.text!
            Task {
                await loginUser(email: loginID.text!, password: password.text!)
            }
        }
        
        
        
    }
    
    func loginUser(email: String, password: String) async {
        do {
            try await AuthenticationManager.shared.signIn(email: email, password: password)
            fetchUserRole(email: email)
            
        } catch {
            
            self.messageLBL.text = "Invalid Login Credentials! Please try again."
        }
    }
    
    func fetchUserRole(email: String) {
            let db = Firestore.firestore()
        AppDelegate.username = loginID.text!
            db.collection("User").document(email).getDocument { [weak self] (document, error) in
                guard let strongSelf = self else { return }
                if let document = document, document.exists {
                    if let userType = document.data()?["UserType"] as? String {
                        print("UserType \(userType)")
                        if userType == "Owner" {
                            let splitViewController = self?.storyboard?.instantiateViewController(withIdentifier: "ownerRootPage") as? UISplitViewController
                            self?.view.window?.rootViewController = splitViewController
                            self?.view.window?.makeKeyAndVisible()
                        } else if userType == "User" {
                            let userViewController = self?.storyboard?.instantiateViewController(withIdentifier: "userRootPage") as? UIViewController
                            
                            self?.view.window?.rootViewController = userViewController
                            self?.view.window?.makeKeyAndVisible()
                        }
                    } else {
                        strongSelf.messageLBL.text = "User type not found"
                    }
                } else {
                    strongSelf.messageLBL.text = "User document not found"
                }
            }

        }
}
