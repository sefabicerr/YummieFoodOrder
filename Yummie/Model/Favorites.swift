//
//  Favorites.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 17.05.2022.
//

import Foundation

class Favorites {
    var favId: String?
    var foodId: String
    var userId: String
    var foodName: String
    var foodPrice: String
    var imageLink: [String]!
    
    init(foodId: String, userId: String, foodName: String ,foodPrice: String) {
        self.foodId = foodId
        self.userId = userId
        self.foodName = foodName
        self.foodPrice = foodPrice
    }
    
    init(dictionary: NSDictionary) {
        favId = dictionary[kFAVID] as? String
        
        if let food = dictionary[kFOODID] {
            foodId = food as! String
        } else { foodId = "" }
        
        if let user = dictionary[kUSERID] {
            userId = user as! String
        } else { userId = "" }
        
        if let fName = dictionary[kFOODNAME] {
            foodName = fName as! String
        } else { foodName = "" }
        
        if let fPrice = dictionary[kFOODPRICE] {
            foodPrice = fPrice as! String
        } else { foodPrice = "" }
        
        if let image = dictionary[kIMAGELINK] {
            imageLink = image as? [String]
        } else { imageLink = [] }
    }
}

//MARK: Saves favorite object
func saveFavoriteToFirebase(favorite: Favorites) {
    let docId = FirebaseReference(.Favorite).document().documentID
    favorite.favId = docId
    FirebaseReference(.Favorite).document(docId).setData(favoriteDictionaryFrom(favorite: favorite) as! [String:Any]) { (error) in
        if error != nil {
            print("kullanıcı kayıt hatası \(error!.localizedDescription)")
        }
    }
}


//MARK: - Helper functions
func favoriteDictionaryFrom(favorite: Favorites) -> NSDictionary {
    return NSDictionary(objects: [favorite.favId, favorite.foodId, favorite.userId, favorite.foodName, favorite.foodPrice, favorite.imageLink], forKeys: [kFAVID as NSCopying,kFOODID as NSCopying, kUSERID as NSCopying, kFOODNAME as NSCopying,kFOODPRICE as NSCopying,kIMAGELINK as NSCopying])
}

//MARK: - To get the selected favorite
func downloadItemsWithIdFromFirebase(with userId: String, with favId: String, completion: @escaping (_ isFav: Bool) -> Void ) {
    FirebaseReference(.Favorite).whereField(kUSERID, isEqualTo: userId).whereField(kFAVID, isEqualTo: favId).getDocuments { (snapshot, error) in
        
        if let snapshot = snapshot {
            if snapshot.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

//MARK: - To get all the favorites
func downloadItemsFromFirebase(with id: String, completion: @escaping (_ favoriteArray: [Favorites]) -> Void){
    
    var favoriteArray: [Favorites] = []
    FirebaseReference(.Favorite).whereField(kUSERID, isEqualTo: id).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(favoriteArray)
            return
        }
        if !snapshot.isEmpty {
            for favoriteDict in snapshot.documents{
                favoriteArray.append(Favorites(dictionary: favoriteDict.data() as NSDictionary))
            }
        }
        completion(favoriteArray)
    }
}

//MARK: - Deletes favorite object
func deleteToFirebase(with favId: String) {
    FirebaseReference(.Favorite).document("\(favId)").delete()
}





