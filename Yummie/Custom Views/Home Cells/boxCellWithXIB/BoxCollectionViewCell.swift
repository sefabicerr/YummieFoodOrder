//
//  BoxCollectionViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 12.05.2022.
//

import UIKit

class BoxCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: BoxCollectionViewCell.self)
    @IBOutlet weak var boxImageView: UIImageView!
    @IBOutlet weak var boxTitleLabel: UILabel!
   
    func setup(_ slide: BoxCellAtHome) {
        boxTitleLabel.text = slide.title
        boxImageView.image = slide.image
    }
}
