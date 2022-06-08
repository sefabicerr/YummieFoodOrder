//
//  FoodInTheCartResponse.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 16.05.2022.
//

import Foundation

class FoodInTheCartResponse : Codable {
    var sepet_yemekler: [FoodInTheCart]?
    var success: Int?
}
