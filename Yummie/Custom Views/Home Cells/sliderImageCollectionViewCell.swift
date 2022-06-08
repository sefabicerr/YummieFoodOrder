//
//  sliderImageCollectionViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.05.2022.
//

import UIKit

class sliderImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing : sliderImageCollectionViewCell.self)
    @IBOutlet weak var sliderImage: UIImageView!
    
    func setup(_ slide: sliderImageAtHome){
        sliderImage.image = slide.image
    }
}
