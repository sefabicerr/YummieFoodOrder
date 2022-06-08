//
//  FavoriteCellCollectionViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 30.05.2022.
//

import UIKit

protocol CellButtonProtocol {
    func deleteFav(indexPath: IndexPath)
}


class FavoriteCellCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FavoriteCellCollectionViewCell.self)

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    var cellButtonProtocol: CellButtonProtocol?
    var indexPath: IndexPath?
    @IBAction func favBtnClicked(_ sender: Any) {
        cellButtonProtocol?.deleteFav(indexPath: indexPath!)
    }
    
    func setup(_ food: Favorites) {
        nameLbl.text = food.foodName
        priceLbl.text = "₺\(food.foodPrice).00"
        if food.imageLink != nil && food.imageLink.count > 0 {
            downloadImages(imageUrls: [food.imageLink.first!]) { (images) in
                self.foodImage.image = images.first as? UIImage
            }
        }
    }
    
}
