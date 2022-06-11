//
//  NoCodeTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.06.2022.
//

import UIKit

class NoCodeTableViewCell: UITableViewCell {

    static let identifier = String(describing: NoCodeTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
