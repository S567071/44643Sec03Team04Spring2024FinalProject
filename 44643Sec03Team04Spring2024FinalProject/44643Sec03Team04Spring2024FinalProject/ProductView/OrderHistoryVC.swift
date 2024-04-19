//
//  OrderHistoryVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Akhila Mylavarapu on 4/19/24.
//
import UIKit
import SDWebImage
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class OrderHistoryVC: UIViewController {

    @IBOutlet weak var bigContainer: UIStackView!
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var PriceLBL: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var messageLBL: UILabel!
        
    @IBOutlet weak var FromDateLBL: UILabel!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ToDateLBL: UILabel!
    
    var selectedProdcut : Product?
    var selectedProductKey = ""
    var images: String?
    var currentPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bigContainer.isHidden = true
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
            navigationItem.rightBarButtonItem = logoutButton
        
        let userCollectionRef = Firestore.firestore().collection("User")
        let userDocRef = userCollectionRef.document(AppDelegate.username)
        
        self.navigationItem.title = "Details"
        
        userDocRef.getDocument { (document, error) in
               if let document = document, document.exists {
             
                   if let data = document.data()  {
                    
                       if let message = data["message"] as? String {
                           self.messageLBL.text = message
                       }
                       
                       if let pickupDate = data["Pickup Date"] as? String {
                           self.FromDateLBL.text = pickupDate
                           
                           if(pickupDate.count < 2) {
                               self.bigContainer.isHidden = true
                           }else {
                               self.bigContainer.isHidden = false
                           }
                       }else{
                           self.bigContainer.isHidden = true
                       }
                       
                       if let dropoffDate = data["Dropoff Date"] as? String {
                           self.ToDateLBL.text = dropoffDate
                       }
                       
                       if let price = data["Price"] as? String {
                           self.PriceLBL.text = price
                       }
                       
                       if let imageURLString = data["ImageURL"] as? String {
                           if let imageURL = URL(string: imageURLString) {
                               self.imageIV.sd_setImage(with: imageURL, completed: nil)
                           }
                       }
                       
                       if let Details = data["Details"] as? String {
                           self.messageLBL.text = Details
                       }
                       
                       if let FirstName = data["FirstName"] as? String {
                           self.name.text = FirstName
                           
                           if let LastName = data["LastName"] as? String {
                               self.name.text = FirstName + " " + LastName
                           }
                           
                       }
                       
                       if let Email = data["Email"] as? String {
                           self.email.text = Email
                       }
                       
                       if let PhoneNumber = data["PhoneNumber"] as? Int {
                           self.phone.text = PhoneNumber.description
                       }
                   }
               } else {
                   print("Document does not exist")
               }
           }
        messageLBL.text = selectedProdcut?.Details
        
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
        FromDateLBL.text = selectedProdcut?.Pickup_Date
        print("FromDate\(price)")
        ToDateLBL.text = selectedProdcut?.Dropoff_Date
        print("ToDate\(price)")

    }
    
    @objc func logoutButtonTapped() {
        let userViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as? UIViewController
        self.view.window?.rootViewController = userViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let userCollectionRef = Firestore.firestore().collection("User")
        let userDocRef = userCollectionRef.document(AppDelegate.username)
        
    
        userDocRef.updateData(["Details" : "" , "Pickup Date" :  "" ,"Dropoff Date" : "" , "LastName" : "" , "ImageURL" : "" , "Price" : ""])
        
        self.navigationController?.popViewController(animated: true)
    }

    func savePostToFirestore(data: [String: Any]) {
        let userCollectionRef = Firestore.firestore().collection("User")
        let userDocRef = userCollectionRef.document(AppDelegate.username)
        let productRef = userCollectionRef.document(selectedProductKey)
        let IsBooked = true
        let prodData: [String: Any] = [
            "Isbooked": IsBooked
        ]
        print("product Key : \(selectedProductKey)")
        userDocRef.updateData(data) { error in
            if let error = error {
                print("Error saving post: \(error.localizedDescription)")
            } else {
                productRef.updateData(prodData)
                print("Post saved successfully!")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thank you!", message: "Your order has been Placed Successfully!😀", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "ToUserPage", sender: self)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func CancleAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ToUserPage", sender: self)
    }
}
