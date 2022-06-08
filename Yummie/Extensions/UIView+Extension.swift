//
//  UIView+Extension.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 19.04.2022.
//

import UIKit

extension UIView {
   @IBInspectable var cornerRadius: CGFloat {
        get{ return self.cornerRadius }
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 15, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask

        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
