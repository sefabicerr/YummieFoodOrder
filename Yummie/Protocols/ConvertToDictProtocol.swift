//
//  ConvertToDictProtocol.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.06.2022.
//

import Foundation


protocol ConvertCodableToDictionaryProtocol {
  func convertToDictionary() -> [String : Any]
    
}
extension ConvertCodableToDictionaryProtocol {
    
  func convertToDictionary() -> [String : Any] {
    let mirror = Mirror(reflecting: self)
    let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
      guard let label = label else { return nil }
      return (label, value)
    }).compactMap { $0 })
    return dict
  }
}
