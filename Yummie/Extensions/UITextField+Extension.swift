//
//  UITextField+Extension.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 23.04.2022.
//
import Foundation
import UIKit

var filled = UIButton.Configuration.filled()
let button = UIButton(configuration: filled, primaryAction: nil)

extension UITextField {
    
    func enablePasswordToggle(){
        filled.background.backgroundColor = .clear
        filled.baseForegroundColor = .black
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightView = button
        rightViewMode = .always
        button.alpha = 1
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
}




