//
//  CheckBoxTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 9.06.2022.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {

    static let identifier = String(describing: CheckBoxTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
}
