//
//  AlertProtocol.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 29.04.2022.
//

import UIKit

typealias AlertActionHandler = (UIAlertAction) -> Void
protocol AlertProtocol {
    func alertMessage(titleInput: String, messageInput: String, doneAction: AlertActionHandler?)
}

extension AlertProtocol where Self: AlertProtocol & UIViewController {
    func alertMessage(titleInput: String = "", messageInput: String = "", doneAction: AlertActionHandler? = nil) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .default, handler: doneAction)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
