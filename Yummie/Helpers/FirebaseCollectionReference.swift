//
//  FirebaseCollectionReference.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 30.04.2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Favorite
    case Adress
    case Ordered
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}

