//
//  Model.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 4/16/24.
//

import Foundation
import Firebase
import FirebaseFirestore


struct Product: Codable{
    let Details: String
    let Dropoff_Date: String
    let Header : String
    let Location: String
    let Pickup_Date: String
    let Price: Double
    let ImageURL:String
}


struct FireStoreOperations {
    static let db = Firestore.firestore()
    static var products: [String: Product] = [:]

    public static func fetchProducts() async {
        do {
            let querySnapshot = try await db.collection("User").getDocuments()
            for document in querySnapshot.documents {
                let productId = document.documentID
                let productData = document.data()
                if(productData["UserType"] as! String == "Owner"){
                    print("Firestore Data: \(productData)")
                    let details = productData["Details"] as? String ?? "N/A"
                    let dropoffDate = productData["Dropoff Date"] as? String ?? "N/A"
                    let header = productData["Header"] as? String ?? "N/A"
                    let location = productData["Location"] as? String ?? "N/A"
                    let pickupDate = productData["Pickup Date"] as? String ?? "N/A"
                    let price = productData["Price"] as? Double ?? 0.0
                    let imageURL = productData["ImageURL"] as? String ?? "N/A"
                    print("MOdel \(price)")
                    let product = Product(Details: details, Dropoff_Date: dropoffDate, Header: header, Location: location, Pickup_Date: pickupDate, Price: price, ImageURL: imageURL)
                    products[productId] = product
                }
            }
        } catch {
            print("Error fetching products: \(error)")
        }
    }
//
//    public static func updateProduct(_ productId: String) async {
//        guard let product = products[productId] else {
//            print("Product not found for ID: \(productId)")
//            return
//        }
//
//        do {
//            try await db.collection("products").document(productId).setData(product)
//        } catch {
//            print("Error updating product: \(error)")
//        }
//    }
}
