//
//  ProductDetailsVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 4/16/24.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import CoreLocation
class ProductDetailsVC: UIViewController {

    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var PriceLBL: UILabel!
    
    @IBOutlet weak var DescriptionTV: UITextView!
    
    @IBOutlet weak var messageLBL: UILabel!
    
    @IBOutlet weak var FromDateTF: UITextField!
    
    @IBOutlet weak var ToDateTF: UITextField!
    
    var selectedProdcut : Product?
    var selectedProductKey = ""
    var images: String?
    var currentPageIndex = 0
    let datepicker = UIDatePicker()
    let storageRef = Storage.storage().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationItem.title = selectedProdcut?.Header ?? ""
        titleLBL.text = selectedProdcut?.Header
        DescriptionTV.text = selectedProdcut?.Details
        
        images = selectedProdcut?.ImageURL
        
        guard let url = URL(string: images ?? "") else {
            print("Invalid URL for image")
            return
        }
    
        imageIV?.sd_setImage(with: url, placeholderImage: nil, options: .progressiveLoad) { (image, error, cacheType, imageUrl) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
       
        imageIV.isUserInteractionEnabled = true
        
        let price = selectedProdcut?.Price ?? 0
        print("selected price\(String(describing: selectedProdcut?.Price))")
        PriceLBL.text = String(format: "$%0.2f", price)
        print("Price\(price)")
        FromDateTF.text = selectedProdcut?.Pickup_Date
        ToDateTF.text = selectedProdcut?.Dropoff_Date
 
    }
    
    @IBAction func BuyProduct(_ sender: Any) {
        let username = AppDelegate.username
        print(username)
        guard let image = imageIV.image else {
                    return messageLBL.text = "Please select an image"
        }
        guard let pickup = FromDateTF.text, !pickup.isEmpty else {
            return messageLBL.text = "Select Pickup Date!"
        }
        guard let dropoff = ToDateTF.text, !dropoff.isEmpty else
        {
            return messageLBL.text = "Select Dropoff Date!"
        }
        guard let price = PriceLBL.text, !price.isEmpty , let _ = Int(price) else{
            return messageLBL.text =  "Enter price details and check given data is correct!"
        }
//        guard let location = locationLBL.text , !location.isEmpty else
//        {
//            return messageLBL.text = "Enter the location details!"
//        }
        guard let address = DescriptionTV.text , !address.isEmpty else {
            return messageLBL.text = "Enter the address details!"
        }
        messageLBL.text = nil
        uploadImageAndSavePost(image: image, pickupDate: pickup, dropoffDate: dropoff, price: price, address: address)
        
    }
    func uploadImageAndSavePost(image: UIImage, pickupDate: String, dropoffDate: String, price: String, address: String) {
            let IsBooked = true
        uploadImage(image) { [self] imageUrl in
                
                let data: [String: Any] = [
                    "Details": address,
                    "Price": "$\(price)",
                    "Pickup Date": pickupDate,
                    "Dropoff Date": dropoffDate,
                    "ImageURL": imageUrl,
                    "Header": titleLBL.text!,
                    "Isbooked": IsBooked
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
        let userCollectionRef = Firestore.firestore().collection("Cart")
        let userDocRef = userCollectionRef.document(AppDelegate.username)
        userDocRef.updateData(data) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                print("Post saved successfully!")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thank you!", message: "Your order has been placed!😀", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "showCategoryHome", sender: self)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func CancleAction(_ sender: Any) {
        
    }
   

}
