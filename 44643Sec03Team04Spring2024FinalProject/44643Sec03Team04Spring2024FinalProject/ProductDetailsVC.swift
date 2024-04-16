//
//  ProductDetailsVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 4/16/24.
//

import UIKit
import SDWebImage

class ProductDetailsVC: UIViewController {

    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var PriceLBL: UILabel!
    
    @IBOutlet weak var DescriptionTV: UITextView!
    
    
    @IBOutlet weak var FromDateTF: UITextField!
    
    @IBOutlet weak var ToDateTF: UITextField!
    
    var selectedProdcut : Product?
    var selectedProductKey = ""
    var images: String?
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = selectedProdcut?.Header ?? ""
        
        DescriptionTV.text = selectedProdcut?.Details
        
        images = selectedProdcut?.ImageURL
        
        guard let url = URL(string: images ?? "") else {
            print("Invalid URL for image")
            return
        }
    
        imageIV?.sd_setImage(with: url, placeholderImage: nil, options: .progressiveLoad) { (image, error, cacheType, imageUrl) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                // Handle error, e.g., show placeholder image or default error image
            }
            // Optionally handle completion or caching events here
        }
       
        imageIV.isUserInteractionEnabled = true
        
        let price = selectedProdcut?.Price ?? 0
        
        PriceLBL.text = String(format: "$%0.2f", price)
        
 
    }
    
   

    @IBAction func BuyProduct(_ sender: Any) {
    }
    
    
    @IBAction func CancleAction(_ sender: Any) {
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
