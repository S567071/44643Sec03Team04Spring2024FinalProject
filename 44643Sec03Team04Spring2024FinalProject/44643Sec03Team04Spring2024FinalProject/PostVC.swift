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
import CoreLocation

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let datepicker = UIDatePicker()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickup()
        dropoff()
        
        // Do any additional setup after loading the view.
        // Request location authorization
              
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            
            // Fetch location information
        fetchLocationInformation(for: location.coordinate)
            
            // Stop updating location to conserve battery
            locationManager.stopUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//        case .denied, .restricted:
//            print("Location access denied")
//            // Handle denied or restricted access
//        case .notDetermined:
//            print("Location authorization not determined")
//            // Prompt the user to grant location access
//            locationManager.requestWhenInUseAuthorization()
//        @unknown default:
//            break
//        }
//    }

        
        // Function to fetch location information
       func fetchLocationInformation(for coordinate: CLLocationCoordinate2D) {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self else { return }
                guard let placemark = placemarks?.first, error == nil else {
                    print("Reverse geocoding failed with error: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Extract location details
                let address = placemark.name ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                // Update UI elements with location information
                DispatchQueue.main.async {
                    self.locationLBL.text = "\(address), \(city), \(state), \(country)"
                }
            }
        }
}
