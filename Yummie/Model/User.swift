//
//  User.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 29.04.2022.
//

import Foundation
import FirebaseAuth
import UIKit

class User {
    var userId: String
    var email: String
    var firsName: String
    var lastName: String
    var fullName: String
    var fullAdress: String?
    var phoneNumber: String?
    var onBoard: Bool
    
    init(userId: String, email:String, firsName:String, lastName: String) {
        self.userId = userId
        self.email = email
        self.firsName = firsName
        self.lastName = lastName
        self.fullName = firsName + " " + lastName
        self.fullAdress = "Görüntülenecek adres bulunamadı"
        self.phoneNumber = ""
        onBoard = false
    }
    
    init(dictionary: NSDictionary) {
        if let id = dictionary[kUSERID] {
            userId = id as! String
        } else { userId = "" }
        
        if let mail = dictionary[kEMAIL] {
            email = mail as! String
        } else { email = "" }
        
        if let fName = dictionary[kFIRSTNAME] {
            firsName = fName as! String
        } else { firsName = "" }
        
        if let lName = dictionary[kLASTNAME] {
            lastName = lName as! String
        } else { lastName = "" }
        
        fullName = firsName + " " + lastName
        
        if let fAdress = dictionary[kFULLADRESS] {
            fullAdress = fAdress as? String
        } else { fullAdress = "" }
        
        if let pNumber = dictionary[kPHONENUMBER] {
            phoneNumber = pNumber as? String
        } else { phoneNumber = "" }
        
        if let onB = dictionary[kONBOARD] {
            onBoard = onB as! Bool
        } else { onBoard = false }
    }
    
    //MARK: Return current user
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return User.init(dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK: Login Func
    class func loginUserWith(email: String, password: String,
                             completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    downloadUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    print("email doğrulanmamış")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    //MARK: Register User
    class func registerUserWith(email: String, password: String,
                                completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(error)
            
            if error == nil {
                //email doğrulama gönder
                authDataResult?.user.sendEmailVerification { (error) in
                    print("doğrulama hatası: ", error?.localizedDescription as Any)
                }
            }
        }
    }
    
    //MARK: Resend Password method
    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
}

//MARK: Download User
func downloadUserFromFirebase(userId: String, email: String) {
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
            print("kullanıcı firebaseden çekildi")
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
        } else {
            print("Kullanıcı firebaseden çekilemedi")
            let user = User(userId: userId, email: email, firsName: "", lastName: "")
            saveUserLocally(userDictionary: userDictionaryFrom(user: user))
            saveUserToFirebase(user: user)
        }
    }
}

//MARK: Save user to Firebase
func saveUserToFirebase(user: User) {
    FirebaseReference(.User).document(user.userId).setData(userDictionaryFrom(user: user) as! [String:Any]) { (error) in
        if error != nil {
            print("kullanıcı kayıt hatası \(error!.localizedDescription)")
        }
    }
}

func saveUserLocally(userDictionary: NSDictionary) {
    UserDefaults.standard.set(userDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: Helper func
func userDictionaryFrom(user:User) -> NSDictionary {
    return NSDictionary(objects: [user.userId, user.email, user.firsName, user.lastName, user.fullName, user.fullAdress ?? "",user.phoneNumber ?? "", user.onBoard], forKeys: [kUSERID as NSCopying,kEMAIL as NSCopying,kFIRSTNAME as NSCopying,kLASTNAME as NSCopying,kFULLNAME as NSCopying,kFULLADRESS as NSCopying,kPHONENUMBER as NSCopying,kONBOARD as NSCopying])
    
}

//MARK: Update User
func updateCurrentUserInFirebase(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
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

