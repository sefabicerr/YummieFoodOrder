//
//  String+Extension.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.05.2022.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
