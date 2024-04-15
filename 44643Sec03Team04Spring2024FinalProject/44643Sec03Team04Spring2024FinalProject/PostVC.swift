//
//  PostVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/12/24.
//

import UIKit

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let datepicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickup()
        dropoff()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var locationLBL: UITextField!
    
    @IBOutlet weak var detailsLBL: UITextField!
    
    @IBOutlet weak var priceLBL: UITextField!
    
    @IBOutlet weak var HeaderLBL: UILabel!
    
    @IBOutlet weak var ImageIV: UIImageView!
    
    @IBAction func uploadIMG(_ sender: UIButton) {
    let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        ImageIV.image = image
        dismiss(animated: true)
    }
    
    @IBOutlet weak var pickupDate: UITextField!
    
    @IBOutlet weak var dropoffDate: UITextField!
    
    
    func pickup() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([done], animated: true)
        pickupDate.inputAccessoryView = toolbar
        pickupDate.inputView  = datepicker
        dropoffDate.inputAccessoryView = toolbar
        dropoffDate.inputView = datepicker
        datepicker.datePickerMode = .date
    }
    @objc func doneClicked() {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        pickupDate.text = format.string(from: datepicker.date)
        dropoffDate.text = format.string(from: datepicker.date)
        self.view.endEditing(true)
        
    }
    @objc func doneClick() {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        dropoffDate.text = format.string(from: datepicker.date)
        self.view.endEditing(true)
        
    }
    
    func dropoff() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClick))
        toolbar.setItems([done], animated: true)
        dropoffDate.inputAccessoryView = toolbar
        dropoffDate.inputView = datepicker
        datepicker.datePickerMode = .date
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
