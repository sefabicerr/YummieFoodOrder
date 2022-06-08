//
//  Adress.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.06.2022.
//

import Foundation

class Adress: ConvertCodableToDictionaryProtocol {
    
    var adressId: String?
    var userId: String
    var bourhood: String
    var street: String
    var homeNumber: String
    var floorNumber: String
    var apartNumber: String
    var description: String
    var latitude: String
    var longitude: String
    
    init(userId: String, bourhood: String, street: String, homeNumber: String, floorNumber: String, apartNumber: String, description: String, latitude: String, longitude: String) {
        
        self.userId = userId
        self.bourhood = bourhood
        self.street = street
        self.homeNumber = homeNumber
        self.floorNumber = floorNumber
        self.apartNumber = apartNumber
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    init(dictionary: NSDictionary) {
        adressId = dictionary[kADRESSID] as? String
        
        if let auserId = dictionary[kUSERID] {
            userId = auserId as! String
        } else { userId = "" }
        
        if let abourhood = dictionary[kBOURHOOD] {
            bourhood = abourhood as! String
        } else { bourhood = "" }
        
        if let astreet = dictionary[kSTREET] {
            street = astreet as! String
        } else { street = "" }
        
        if let ahomeNumber = dictionary[kHOMENUMBER] {
            homeNumber = ahomeNumber as! String
        } else { homeNumber = "" }
        
        if let afloorNumber = dictionary[kFLOORNUMBER] {
            floorNumber = afloorNumber as! String
        } else { floorNumber = "" }
        
        if let aapartNumber = dictionary[kAPARTNUMBER] {
            apartNumber = aapartNumber as! String
        } else { apartNumber = "" }
        
        if let adescription = dictionary[kDESCRIPTION] {
            description = adescription as! String
        } else { description = "" }
        
        if let alatitude = dictionary[kLATITUDE] {
            latitude = alatitude as! String
        } else { latitude = "" }
        
        if let alongitude = dictionary[kLONGITUDE] {
            longitude = alongitude as! String
        } else { longitude = "" }
        
    }
}

//MARK: Save adress to firebase
func saveAdressToFirebase(adress: Adress) {
    let docId = FirebaseReference(.Adress).document().documentID
    adress.adressId = docId
    FirebaseReference(.Adress).document(docId).setData(adress.convertToDictionary()) { (error) in
        if error != nil {
            print("kullanıcı kayıt hatası \(error!.localizedDescription)")
        }
    }
}

//MARK: Update User Adress
func updateUserAdressInFirebase(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        let userobject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userobject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(User.currentId()).updateData(withValues) { (error) in
            completion(error)
            
            if error == nil {
                saveUserLocally(userDictionary: userobject)
            }
        }
    }
}

//MARK: Download all adress from firebase
func downloadAdressFromFirebase(with id: String, completion: @escaping (_ adressArray: [Adress]) -> Void){
    var adressArray: [Adress] = []
    FirebaseReference(.Adress).whereField(kUSERID, isEqualTo: id).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(adressArray)
            return
        }
        if !snapshot.isEmpty {
            for adressDict in snapshot.documents{
                adressArray.append(Adress(dictionary: adressDict.data() as NSDictionary))
            }
        }
        completion(adressArray)
    }
}

//MARK: Download selected adress from firebase
func downloadUserAdressFromFirebase(with id: String, completion: @escaping (_ adress: String) -> Void){
    var adress = ""
    FirebaseReference(.User).whereField(kUSERID, isEqualTo: id).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(adress)
            return
        }
        if !snapshot.isEmpty {
            for userDict in snapshot.documents{
                adress = User(dictionary: userDict.data() as NSDictionary).fullAdress ?? ""
            }
        }
        completion(adress)
    }
}

//MARK: - Deletes adress object
func deleteAdressToFirebase(with adressId: String) {
    FirebaseReference(.Adress).document("\(adressId)").delete()
}
