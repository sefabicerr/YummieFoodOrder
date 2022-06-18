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
    
    func shake(horizantaly: CGFloat = 0, verticaly: CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - horizantaly,
                                                       y: self.center.y - verticaly))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + horizantaly,
                                                     y: self.center.y - verticaly))
        self.layer.add(animation, forKey: "position")
    }
}




