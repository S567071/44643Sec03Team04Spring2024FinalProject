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
        self.setDefultValues()
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
    
    var validationMessage = ""
    
    @IBAction func registerAction(_ sender: UIButton) {
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
                    let userType = self.userSwitch.isEnabled ? UserType.User : UserType.Owner
                    
                    let userData = [
                        "Email" : self.emailIdTF.text ?? "",
                        "FirstName" : self.firstNameTF.text ?? "",
                        "PhoneNumber" : Int(self.phoneNumberTF.text ?? "") ?? 0,
                        "LastName" : self.lastNameTF.text ?? "",
                        "UserType" : userType
                    ]
                    
                    guard let userId = result?.user.uid else { return }
                    
                    
                    Firestore.firestore().collection("UserData").document(userId).setData(userData) { error in
                        if (error != nil) {
                          // Handle errors while storing user data
                            self.showAlert(title: "User data storing failed.", message: "Something went wrong.", buttonText: "close")
                        } else {
                          // User creation and data storage successful
                            self.showAlert(title: "Registered Successfully.", message: "Registered successfully. Please login.", buttonText: "Ok")
                            self.setDefultValues()
                        }
                    }
                }
            };
        }
    }
    
    @IBAction func userAction(_ sender: UISwitch) {
        if (sender.isOn) {
            self.ownerSwitch.isOn = false
        }
    }
    
    @IBAction func ownerAction(_ sender: UISwitch) {
        if (sender.isOn) {
            self.userSwitch.isOn = false
        }
    }
    
    private func showAlert(title :String, message :String, buttonText :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setDefultValues() {
        self.emailIdTF.text = ""
        self.phoneNumberTF.text = ""
        self.firstNameTF.text = ""
        self.lastNameTF.text = ""
        self.passwordTF.text = ""
        self.confirmPasswordTF.text = ""
        self.ownerSwitch.isOn = false
        self.userSwitch.isOn = false
        
        self.emailIdTF.layer.borderWidth = 0;
        self.phoneNumberTF.layer.borderWidth = 0;
        self.firstNameTF.layer.borderWidth = 0;
        self.lastNameTF.layer.borderWidth = 0;
        self.passwordTF.layer.borderWidth = 0;
        self.confirmPasswordTF.layer.borderWidth = 0;
    }
    
    private func validateEmail() {
        let email = self.emailIdTF.text ?? ""
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (!emailPred.evaluate(with: email)){
            self.validationMessage += "Email is invalid.\n"
            self.emailIdTF.layer.borderWidth = 1.0
            self.emailIdTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validatePhoneNum() {
        let phoneNumber = self.phoneNumberTF.text ?? ""
        if (!phoneNumber.allSatisfy({$0.isNumber}) || phoneNumber.count != 10) {
            self.validationMessage += "Phone number is invalid.\n";
            self.phoneNumberTF.layer.borderWidth = 1.0
            self.phoneNumberTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validateFirstName() {
        let firstname = self.firstNameTF.text ?? ""
        if (!firstname.allSatisfy({$0.isLetter}) || firstname.count == 0) {
            self.validationMessage += firstname.count == 0 ? "First name cannot be empty.\n" : "First name cannot contain any numbers and symbols.\n"
            self.firstNameTF.layer.borderWidth = 1.0
            self.firstNameTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validateLastName() {
        let lastName = self.lastNameTF.text ?? ""
        if (!lastName.allSatisfy({$0.isLetter}) || lastName.count == 0) {
            self.validationMessage += lastName.count == 0 ? "Last name cannot be empty.\n" : "Last name cannot contain any numbers and symbols.\n"
            self.lastNameTF.layer.borderWidth = 1.0
            self.lastNameTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validatePassword() {
        let password = self.passwordTF.text ?? ""
        if (password.count < 8) {
            self.validationMessage += "Password should be greater than or equal to 8 characters.\n"
            self.passwordTF.layer.borderWidth = 1.0
            self.passwordTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validateConfirmPassword() {
        let password = self.passwordTF.text ?? ""
        let confirmPassword = self.confirmPasswordTF.text ?? ""
        if (confirmPassword != password || password.count == 0) {
            self.validationMessage += "Confirmated password doesn't match with password.\n"
            self.confirmPasswordTF.layer.borderWidth = 1.0
            self.confirmPasswordTF.layer.borderColor = CGColor.init(red: 256, green: 0, blue: 0, alpha: 0.7);
        }
    }
    
    private func validateUserOrOwner() {
        if (!self.ownerSwitch.isOn && !self.userSwitch.isOn) {
            self.validationMessage += "Select User or Owner.\n"
        }
    }
    
    private func validateInputFields() -> Bool {
        self.validationMessage = ""
        self.validateEmail()
        self.validatePhoneNum()
        self.validateFirstName()
        self.validateLastName()
        self.validatePassword()
        self.validateConfirmPassword()
        self.validateUserOrOwner()
        
        if (self.validationMessage.count > 0) {
            self.showAlert(title: "Invalid Inputs", message: self.validationMessage, buttonText: "Close")
            self.validationMessage = ""
            return false;
        }
        else {
            return true;
        }
        
    }
}
