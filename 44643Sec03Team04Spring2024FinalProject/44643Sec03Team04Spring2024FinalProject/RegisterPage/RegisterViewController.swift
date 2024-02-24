//
//  RegisterViewController.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 2/21/24.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownerSwitch.isOn = false
        self.userSwitch.isOn = false
        self.registerButton.isEnabled = false
    }

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var userSwitch: UISwitch!
    @IBOutlet weak var userTF: UILabel!
    @IBOutlet weak var ownerSwitch: UISwitch!
    @IBOutlet weak var ownerTF: UILabel!
    
    @IBAction func registerAction(_ sender: UIButton) {
        self.validateInputFields()
    }
    
    @IBAction func userAction(_ sender: UISwitch) {
    }
    
    @IBAction func ownerAction(_ sender: UISwitch) {
    }
    
    private func validateInputFields() {
        let email = self.emailIdTF.text ?? ""
        let phoneNumber = self.phoneNumberTF.text ?? ""
        let firstname = self.firstNameTF.text ?? ""
        let lastName = self.lastNameTF.text ?? ""
        let password = self.passwordTF.text ?? ""
        let confirmPassword = self.confirmPasswordTF.text ?? ""
        
        var validationMessage = ""
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (!emailPred.evaluate(with: email)){
            validationMessage += "Email is invalid.\n"
            self.emailIdTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (!phoneNumber.allSatisfy({$0.isNumber}) && phoneNumber.count != 10) {
            validationMessage += "Phone number is invalid.\n";
            self.phoneNumberTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (firstname.count == 0 && lastName.count == 0) {
            validationMessage += "First name and Last Name cannot be empty.\n"
            self.firstNameTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (password.count < 8) {
            validationMessage += "Password should be greater than or equal to 8 characters.\n"
            self.passwordTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (confirmPassword != password) {
            validationMessage += "Confirmated password doesn't match with password.\n"
            self.confirmPasswordTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (validationMessage.count > 0) {
            let alert = UIAlertController(title: "Invalid Inputs", message: validationMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
