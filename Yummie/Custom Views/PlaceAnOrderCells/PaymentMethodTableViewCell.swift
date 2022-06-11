//
//  PaymentMethodTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 10.06.2022.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: PaymentMethodTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    
}
