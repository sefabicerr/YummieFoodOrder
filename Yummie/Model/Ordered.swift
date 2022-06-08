//
//  Ordered.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 6.06.2022.
//

import Foundation

class Ordered: ConvertCodableToDictionaryProtocol {
    var orderedId: String?
    var userId: String
    var date: String
    var totalPrice: String
    var adress: String
    
    init(userId: String, date: String, totalPrice: String, adress: String){
        self.userId = userId
        self.date = date
        self.totalPrice = totalPrice
        self.adress = adress
    }
    
    init(dictionary: NSDictionary){
        orderedId = dictionary[kORDEREDID] as? String
        
        if let ouserId = dictionary[kUSERID] {
            userId = ouserId as! String
        } else { userId = "" }
        
        if let odate = dictionary[kDATE] {
            date = odate as! String
        } else { date = "" }
        
        if let ototalPrice = dictionary[kTOTALPRICE] {
            totalPrice = ototalPrice as! String
        } else { totalPrice = "" }
        
        if let oadress = dictionary[kADRESS] {
            adress = oadress as! String
        } else { adress = "" }
        
    }
}

//MARK: - Save ordered to firebase
func saveOrderedToFirebase(ordered: Ordered) {
    let docId = FirebaseReference(.Ordered).document().documentID
    ordered.orderedId = docId
    FirebaseReference(.Ordered).document(docId).setData(ordered.convertToDictionary()) { (error) in
        if error != nil {
            print("kullanıcı kayıt hatası \(error!.localizedDescription)")
        }
    }
}

//MARK: Download all ordered from firebase
func downloadOrderedFromFirebase(with id: String, completion: @escaping (_ orderedArray: [Ordered]) -> Void){
    var orderedArray: [Ordered] = []
    FirebaseReference(.Ordered).whereField(kUSERID, isEqualTo: id).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(orderedArray)
            return
        }
        if !snapshot.isEmpty {
            for orderedDict in snapshot.documents{
                orderedArray.append(Ordered(dictionary: orderedDict.data() as NSDictionary))
            }
        }
        completion(orderedArray)
    }
}

