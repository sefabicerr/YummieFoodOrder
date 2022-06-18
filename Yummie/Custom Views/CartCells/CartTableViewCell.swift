//
//  CartTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 16.05.2022.
//

import UIKit
import Kingfisher

class CartTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: CartTableViewCell.self)
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodCountLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!

    func setup(_ slide:FoodInTheCart) {
        let foodTotalPrice = Int(slide.yemek_fiyat!)! * Int(slide.yemek_siparis_adet!)!
        foodNameLbl.text = slide.yemek_adi
        foodPriceLbl.text = "₺\(foodTotalPrice).00"
        foodCountLbl.text = "\(slide.yemek_siparis_adet!) adet"
        foodImage.kf.setImage(with: "\(kGETALLIMAGESLINK)\(slide.yemek_resim_adi!)".asUrl)
    }
}
