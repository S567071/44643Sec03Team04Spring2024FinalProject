//
//  ModificationVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/16/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import FirebaseStorage

class ModificationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userData: [String: Any]?
    
    let datepicker = UIDatePicker()
    let locationManager = CLLocationManager()
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
        
        pickup()
        dropoff()
    }
    
    @IBOutlet weak var headerLBL: UILabel!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var messageLBL: UILabel!
    
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
        imageIV.image = image
        dismiss(animated: true)
    }
    @IBOutlet weak var pickupDateTF: UITextField!
    
    @IBOutlet weak var dropoffDateTF: UITextField!
    
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var detailsTF: UITextField!
    
    @IBAction func updateBTN(_ sender: UIButton) {
        guard let image = imageIV.image else {
            return messageLBL.text = "Please select an image"
        }
        guard let pickup = pickupDateTF.text, !pickup.isEmpty else {
            return messageLBL.text = "Select Pickup Date!"
        }
        guard let dropoff = dropoffDateTF.text, !dropoff.isEmpty else
        {
            return messageLBL.text = "Select Dropoff Date!"
        }
        guard let priceString = priceTF.text, !priceString.isEmpty , let price = Double(priceString) else{
            return messageLBL.text =  "Enter price details and check given data is correct!"
        }
        guard let location = locationTF.text , !location.isEmpty else
        {
            return messageLBL.text = "Enter the location details!"
        }
        guard let address = detailsTF.text , !address.isEmpty else {
            return messageLBL.text = "Enter the address details!"
        }
        messageLBL.text = nil
        uploadImageAndSavePost(image: image, pickupDate: pickup, dropoffDate: dropoff, price: Double(price), location: location, address: address)
    }
    
    func fetchData() {
        Firestore.firestore().collection("User").document(AppDelegate.username).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                self.userData = document.data()
                self.updateUI()
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let header = userData["Header"] as? String {
            headerLBL.text = header
        } else {
            print("Header is nil.")
        }
        
        if let imageUrlString = userData["ImageURL"] as? String, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self?.imageIV.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            print("ImageURL is nil or invalid.")
        }
        
        if let pickupDateString = userData["Pickup Date"] as? String, !pickupDateString.isEmpty,
           let pickupDate = dateFormatter.date(from: pickupDateString) {
            pickupDateTF.text = dateFormatter.string(from: pickupDate)
        } else {
            print("PickupDate is empty or nil.")
        }
        
        if let dropoffDateString = userData["Dropoff Date"] as? String, !dropoffDateString.isEmpty,
           let dropoffDate = dateFormatter.date(from: dropoffDateString) {
            dropoffDateTF.text = dateFormatter.string(from: dropoffDate)
        } else {
            print("DropoffDate is empty or nil.")
        }
        
        if let price = userData["Price"] as? Double {
            priceTF.text = "\(price)"
        } else {
            print("Price is nil.")
        }
        
        if let location = userData["Location"] as? String {
            locationTF.text = location
        } else {
            print("Location is nil.")
        }
        
        if let details = userData["Details"] as? String {
            detailsTF.text = details
        } else {
            print("Details is nil.")
        }
    }
    func pickup() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([flexibleSpace, done], animated: true)
        pickupDateTF.inputAccessoryView = toolbar
        let pickerHeight: CGFloat = 200
        datepicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - pickerHeight, width: UIScreen.main.bounds.width, height: pickerHeight)
        pickupDateTF.inputView = datepicker
        datepicker.datePickerMode = .date
    }
    func dropoff() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClick))
        toolbar.setItems([flexibleSpace, done], animated: true)
        dropoffDateTF.inputAccessoryView = toolbar
        let pickerHeight: CGFloat = 200
        datepicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - pickerHeight, width: UIScreen.main.bounds.width, height: pickerHeight)
        dropoffDateTF.inputView = datepicker
        datepicker.datePickerMode = .date
    }
    @objc func doneClicked() {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        pickupDateTF.text = format.string(from: datepicker.date)
        self.view.endEditing(true)
        
    }
    @objc func doneClick() {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        dropoffDateTF.text = format.string(from: datepicker.date)
        self.view.endEditing(true)
        
    }
    func uploadImageAndSavePost(image: UIImage, pickupDate: String, dropoffDate: String, price: Double, location: String, address: String) {
        uploadImage(image) { [self] imageUrl in
            let data: [String: Any] = [
                "Location": location,
                "Details": address,
                "Price": price,
                "Pickup Date": pickupDate,
                "Dropoff Date": dropoffDate,
                "ImageURL": imageUrl
            ]
            self.savePostToFirestore(data: data)
        }
    }
    func uploadImage(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            imageRef.downloadURL { (url, error) in
                if let imageUrl = url?.absoluteString {
                    completion(imageUrl)
                } else {
                    print("Failed to get download URL for image")
                }
            }
        }
    }
    func savePostToFirestore(data: [String: Any]) {
        let userCollectionRef = Firestore.firestore().collection("User")
        let userDocRef = userCollectionRef.document(AppDelegate.username)
        userDocRef.updateData(data) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                print("Post saved successfully!")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thank you!", message: "Your order has been updated successfully!😀", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "showAccount", sender: self)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
