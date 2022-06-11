//
//  AddCodeTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.06.2022.
//

import UIKit

class AddCodeTableViewCell: UITableViewCell {

    static let identifier = String(describing: AddCodeTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
