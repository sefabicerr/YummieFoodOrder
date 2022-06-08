//
//  AdressTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.06.2022.
//

import UIKit

protocol TrashProtocol {
    func deleteAdressProtocolFunc(indexPath: IndexPath)
}

class AdressTableViewCell: UITableViewCell {

    static let identifier = String(describing: AdressTableViewCell.self)
    
    @IBOutlet weak var adressLbl: UILabel!
    var trashProtocol : TrashProtocol?
    var indexPath : IndexPath?
    
    func setup(_ adress: String) {
        adressLbl.text = adress
    }
    
    
    @IBAction func trashBtnClicked(_ sender: Any) {
        trashProtocol?.deleteAdressProtocolFunc(indexPath: indexPath!)
    }
    
    
}
