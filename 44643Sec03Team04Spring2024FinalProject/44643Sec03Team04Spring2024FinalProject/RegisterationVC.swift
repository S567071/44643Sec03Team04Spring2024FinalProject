//
//  RegisterationVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 3/6/24.
//

import UIKit
import Firebase

class RegisterationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ownerSwitch.isOn = false
        self.userSwitch.isOn = true
        //self.registerButton.isEnabled = false
    }

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var userSwitch: UISwitch!
    @IBOutlet weak var ownerSwitch: UISwitch!
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard let email = emailIdTF.text, !email.isEmpty,
                      let phoneNumber = phoneNumberTF.text, !phoneNumber.isEmpty,
                      let firstName = firstNameTF.text, !firstName.isEmpty,
                      let lastName = lastNameTF.text, !lastName.isEmpty,
                      let password = passwordTF.text, !password.isEmpty,
                      let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
                    showAlert(message: "Please fill in all fields")
                    return
                }
        let isFormValid = self.validateInputFields()
        var validationMessage  = ""
        if (isFormValid) {
            FirebaseAuth.Auth.auth().createUser(withEmail: self.emailIdTF.text ?? "", password: self.passwordTF.text ?? "") { result, error in
                if (error != nil) {
                    if let error = error as NSError? {
                        if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                            switch errorCode {
                                case .emailAlreadyInUse :
                                    validationMessage = "Email is already in use."
                                default :
                                    validationMessage = "Something is failed."
                            }
                        }
                    }
                    self.showAlert(title: "Account creation failed.", message: validationMessage, buttonText: "close")
                }
                else {
                    self.showAlert(title: "Registered Successfully.", message: "Registered successfully. Please login.", buttonText: "Ok")
                    let role = self.ownerSwitch.isOn ? "Owner" : (self.userSwitch.isOn ? "User" : "Guest")
                    self.setUserDetailsAndRole(email: email, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, role: role)
                    self.performSegue(withIdentifier: "loginPage", sender: self)
                }
            };
        }
    }
    
    func setUserDetailsAndRole(email: String, phoneNumber: String, firstName: String, lastName: String, role: String) {
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "email": email,
                "phoneNumber": phoneNumber,
                "firstName": firstName,
                "lastName": lastName,
                "role": role
            ]

            db.collection("users").document(email).setData(userData) { error in
                if let error = error {
                    print("Error setting user details and role: \(error.localizedDescription)")
                } else {
                    print("User details and role set successfully")
                    // Navigate to the next screen or perform appropriate action
                }
            }
        }
    
    @IBAction func userAction(_ sender: UISwitch) {
    }
    
    @IBAction func ownerAction(_ sender: UISwitch) {
    }
    
    private func showAlert(title :String, message :String, buttonText :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateInputFields() -> Bool {
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
        
        if (!phoneNumber.allSatisfy({$0.isNumber}) || phoneNumber.count != 10) {
            validationMessage += "Phone number is invalid.\n";
            self.phoneNumberTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (!firstname.allSatisfy({$0.isLetter}) || firstname.count == 0) {
            validationMessage += firstname.count == 0 ? "First name cannot be empty.\n" : "First name cannot contain any numbers and symbols.\n"
            self.firstNameTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
        
        if (!lastName.allSatisfy({$0.isLetter}) || lastName.count == 0) {
            validationMessage += lastName.count == 0 ? "Last name cannot be empty.\n" : "Last name cannot contain any numbers and symbols.\n"
            self.lastNameTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
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
            self.showAlert(title: "Invalid Inputs", message: validationMessage, buttonText: "Close")
            return false;
        }
        else {
            return true;
        }
        
    }
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
}
