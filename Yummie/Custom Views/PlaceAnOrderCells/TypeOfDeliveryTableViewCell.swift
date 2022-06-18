//
//  TypeOfDeliveryTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 10.06.2022.
//

import UIKit

class TypeOfDeliveryTableViewCell: UITableViewCell {

    static let identifier = String(describing: TypeOfDeliveryTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
}
