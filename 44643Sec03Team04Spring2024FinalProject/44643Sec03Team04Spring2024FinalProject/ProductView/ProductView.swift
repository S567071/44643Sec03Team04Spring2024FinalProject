//
//  ProductView.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Laxminarayana Yadav Pakanati on 4/16/24.
//

import UIKit

class ProductView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var descriptionLBL: UILabel!
    
   // @IBOutlet weak var ratingLBL: UILabel!
    
    //@IBOutlet weak var discountAndActualPriceLBL: UILabel!
    
    @IBOutlet weak var productIMG: UIImageView!
    
    
    private func configureContentView(_ contentView: UIView) {
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if let productView = contentView as? ProductView {
            configureProductView(productView)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    func customInit() {
        guard let contentView = loadContentViewFromNib() else {
            return
        }
        addSubview(contentView)
        configureContentView(contentView)
    }

    private func loadContentViewFromNib() -> UIView? {
        return Bundle.main.loadNibNamed("ProductView", owner: self, options: nil)?.first as? UIView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    private func configureProductView(_ productView: ProductView) {
        productView.productIMG.isUserInteractionEnabled = true
        productView.productIMG.contentMode = .scaleToFill
        productView.layer.cornerRadius = 6
        productView.layer.borderColor = UIColor.darkGray.cgColor
        productView.layer.borderWidth = 2.0
        productView.clipsToBounds = true
    }

}

