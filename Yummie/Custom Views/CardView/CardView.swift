//
//  CardView.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.05.2022.
//

import Foundation
import UIKit

class CardView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        intialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        intialSetup()
    }
    
    private func intialSetup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        cornerRadius = 10
    }
}
