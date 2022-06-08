//
//  SelectedAdressTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 4.06.2022.
//

import UIKit

class SelectedAdressTableViewCell: UITableViewCell {

    static let identifier = String(describing: SelectedAdressTableViewCell.self)
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var adressLbl: UILabel!
    
    func setup(_ adress: String) {
        adressLbl.text = adress
    }
    
    func createBackView(){
        backView.roundCorners([.bottomRight, .topRight], radius: 22)
    }
    
}
