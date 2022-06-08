//
//  ActivityIndicatorProtocol.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 3.05.2022.
//

import UIKit
import NVActivityIndicatorView

protocol ActivityIndicatorProtocol {
    func showLoadingIndicator(activityIndicator: NVActivityIndicatorView?)
    func hideLoadingIndicator(activityIndicator: NVActivityIndicatorView?)
}

extension ActivityIndicatorProtocol where Self: ActivityIndicatorProtocol & UIViewController {
    func showLoadingIndicator(activityIndicator: NVActivityIndicatorView? = nil) {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    func hideLoadingIndicator(activityIndicator: NVActivityIndicatorView? = nil) {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    
    func createActivityIndicator() -> NVActivityIndicatorView {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: UIColor(named: "appColor"), padding: nil)
        return activityIndicator
    }
}

