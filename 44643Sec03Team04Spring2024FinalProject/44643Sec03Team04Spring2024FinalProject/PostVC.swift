//
//  PostVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/12/24.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

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
    
    @IBOutlet weak var messageLBL: UILabel!
    
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
    
    @IBAction func post(_ sender: UIButton) {
        let username = AppDelegate.username
        print(username)
        guard ImageIV.image != nil else {
            return messageLBL.text  =    "Please select an image"
        }
        guard let pickup = pickupDate.text, !pickup.isEmpty else {
            return messageLBL.text = "Select Pickup Date!"
        }
        guard let dropoff = dropoffDate.text, !dropoff.isEmpty else
        {
            return messageLBL.text = "Select Dropoff Date!"
        }
        guard let price = priceLBL.text, !price.isEmpty , let _ = Int(price) else{
            return messageLBL.text =  "Enter price details and check given data is correct!"
        }
        guard let location = locationLBL.text , !location.isEmpty else
        {
            return messageLBL.text = "Enter the location details!"
        }
        guard let address = detailsLBL.text , !address.isEmpty else {
            return messageLBL.text = "Enter the address details!"
        }
        messageLBL.text = nil
        let data: [String: Any] = [
                "Location": self.locationLBL.text!,
                "Address Details": self.detailsLBL.text!,
                "Price": "$\(self.priceLBL.text!)",
                "Pickup Date": self.pickupDate.text!,
                "Dropoff Date": self.dropoffDate.text!
                
                // Add other fields as needed
            ]
        savePostToFirestore(data: data, userEmail: AppDelegate.username)
        
        let alert = UIAlertController(title: "Thank you!", message: "Your order has been posted successfully!😀", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBTN(_ sender: UIButton) {
    }
    
    func savePostToFirestore(data: [String: Any], userEmail: String) {
        // Reference to the User collection
        let userCollectionRef = Firestore.firestore().collection("User")
        
        // Reference to the document under the User collection with the logged-in user's email as the document ID
        let userDocRef = userCollectionRef.document(userEmail)
        
        // Update the document with the provided data
        userDocRef.updateData(data) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                print("Post saved successfully!")
            }
        }
    }




}
