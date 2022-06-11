//
//  NoteTableViewCell.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 9.06.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let identifier = String(describing: NoteTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var noteLbl: UILabel!
    
}
