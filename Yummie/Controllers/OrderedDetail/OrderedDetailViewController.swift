//
//  OrderedDetailViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.06.2022.
//

import UIKit

class OrderedDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var typeOfDeliveryLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var basketPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    //MARK: - Vars
    var ordered: Ordered?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let ordered = ordered else {return}
        setupUIInfo(order: ordered)
        
    }
    
    private func setupUIInfo(order: Ordered) {
        dateLbl.text = order.date
        adressLbl.text = order.adress
        if order.orderNote == nil {
            noteLbl.text = "Sipariş notunuz yok"
        } else {
            noteLbl.text = order.orderNote
        }
        typeOfDeliveryLbl.text = order.typeOfDelivery
        paymentMethodLbl.text = order.paymentMethod
        basketPrice.text = "₺\(order.totalPrice).00"
        totalPrice.text = "₺\(order.price ?? "0").00"
        let totalPrice = Int(order.totalPrice)! - Int(order.price!)!
        self.discountPrice.text = "₺\(totalPrice).00"
    }


}
