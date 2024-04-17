//
//  UserHomeVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 4/16/24.
//
import UIKit
import SDWebImage
import Firebase

class UserHomeVC: UIViewController {

    @IBOutlet var productViewCLCTN: [ProductView]!
    
    @IBOutlet weak var userLBL: UILabel!
    var selectedProduct: Product?
    
    var selectedProductKey = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ProductDetails" {
            
            let vc = segue.destination as! ProductDetailsVC
            vc.selectedProdcut = selectedProduct
            vc.selectedProductKey = self.selectedProductKey
        }
        
    }
    var userData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        Task {
            await FireStoreOperations.fetchProducts()
            displayProducts()

        }
    }
    func fetchUserData() {
       
        Firestore.firestore().collection("User").document(AppDelegate.username).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                self.userData = document.data()
                self.updateUI()
                print(userData!)
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

        // Update UI elements with user data
        if let firstName = userData["FirstName"] as? String{
            self.userLBL.text = "Hi...\(firstName)!"
        } else {
            print("First name  is nil.")
        }
    }
    private func displayProducts() {
        var i = 0
        var ProductKeys : [String] = []
        ProductKeys = [String](FireStoreOperations.products.keys)
        for key in ProductKeys {
            guard let product = FireStoreOperations.products[key] else {
                continue
            }
            let productView = productViewCLCTN[i]
            configureProductView(productView, with: product)
            setupGestureRecognizer(for: productView)
            i += 1
        }
    }
    
    private func configureProductView(_ productView: ProductView, with product: Product) {
        print("Image : \(product.ImageURL) Details: \(product.Details) Heading: \(product.Header)")
        setTag(for: productView)
        loadImage(for: productView, with: product.ImageURL)
        setDetails(for: productView, with: product.Details)
        setHeader(for: productView, with: product.Header)
        applyStyling(for: productView)
    }
    
    private func setTag(for productView: ProductView) {
        productView.tag = productViewCLCTN.firstIndex(of: productView) ?? 0
        
    }
    
    private func setDetails(for productView: ProductView, with title: String) {
        productView.descriptionLBL?.text = title
        print("Desc \(title)")
    }

    private func setHeader(for productView: ProductView, with Header: String) {
        productView.titleLBL?.text = Header
        print("Title \(Header)")

    }

    private func loadImage(for productView: ProductView, with urlStr: String) {
        guard let imageUrl = URL(string: urlStr) else {
                print("Invalid URL string: \(urlStr)")
                return
            }
            
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        productView.productIMG?.image = UIImage(data: imageData)
                    }
                } else {
                    print("Failed to load image data from URL: \(imageUrl)")
                }
            }
//        guard let url = URL(string: urlStr) else {
//            print("Invalid URL for image")
//            return
//        }
//
//        productView.productIMG?.sd_setImage(with: url, placeholderImage: nil, options: .progressiveLoad) { (image, error, cacheType, imageUrl) in
//            if let error = error {
//                print("Error loading image: \(error.localizedDescription)")
//                // Handle error, e.g., show placeholder image or default error image
//            }
//            // Optionally handle completion or caching events here
//        }
    }

   
    private func setupGestureRecognizer(for productView: ProductView) {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        productView.addGestureRecognizer(longPressGesture)
    }
    
    
    private func applyStyling(for productView: ProductView) {
        productView.layer.cornerRadius = 4
        productView.layer.borderColor = UIColor.black.cgColor
        productView.layer.borderWidth = 2
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        var ProductKeys : [String] = []
        ProductKeys = [String](FireStoreOperations.products.keys)
        if gesture.state == .began {
            
            guard let productView = gesture.view as? ProductView else {
                return
            }
            
            let tag = productView.tag
            let key = ProductKeys[tag]
            self.selectedProductKey = key
            selectedProduct = FireStoreOperations.products[key]
            performSegue(withIdentifier: "ProductDetails", sender: self)
        }
    }
    


}
