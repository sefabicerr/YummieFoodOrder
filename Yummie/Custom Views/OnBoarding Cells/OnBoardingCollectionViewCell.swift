//
//  OnBoardingCollectionViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 19.04.2022.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing : OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLbl: UILabel!
    @IBOutlet weak var slideDescriptionLbl: UILabel!
    
    func setup(_ slide: OnBoardingSlide){
        slideImageView.image = slide.image
        slideTitleLbl.text = slide.title
        slideDescriptionLbl.text = slide.description
    } 
}
