//
//  LoginVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 2/23/24.
//

import UIKit

class LoginVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    
    @IBOutlet weak var loginID: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var selectCATEG: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let options = ["Admin", "User"]
    
    var selectedOption : String = "Admin"
    
    @IBAction func register(_ sender: UIButton) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "RegisterationVC") as! RegisterationVC
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return options.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return options[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedOption = options[row]
            
        }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if(selectedOption.elementsEqual("Admin")){
            self.performSegue(withIdentifier: "Owner", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "userHomePage", sender: self)
        }
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
