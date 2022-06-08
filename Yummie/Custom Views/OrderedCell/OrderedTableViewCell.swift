//
//  OrderedTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 7.06.2022.
//

import UIKit

class OrderedTableViewCell: UITableViewCell {

    static let identifier = String(describing: OrderedTableViewCell.self)
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    func setup(ordered: Ordered) {
        dateLbl.text = ordered.date
        totalPriceLbl.text = ordered.totalPrice
        adressLbl.text = ordered.adress
    }
}
