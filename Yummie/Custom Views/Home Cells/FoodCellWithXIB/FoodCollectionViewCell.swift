//
//  FoodCollectionViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.05.2022.
//

import UIKit
import Kingfisher

class FoodCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: FoodCollectionViewCell.self)
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!

    func setup(_ slide: Foods) {
        foodNameLbl.text = slide.yemek_adi
        foodPriceLbl.text = "₺\(slide.yemek_fiyat!).00"
        foodImage.kf.setImage(with: "\(kGETALLIMAGESLINK)\(slide.yemek_resim_adi!)".asUrl)
    }
}
