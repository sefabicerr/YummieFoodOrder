//
//  Service.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.05.2022.
//

import Foundation
import Alamofire

class Service {
    
    //MARK: - Get all foods from api
    final class func showAllFoods(_ completion: @escaping([Foods]) -> Void){
        AF.request(kGETALLFOODSLINK,method:.get).response { response in
            if let data = response.data {
                do {
                    let answer = try JSONDecoder().decode(FoodsResponse.self, from: data)
                    var list = [Foods]()
                    
                    if let answerList = answer.yemekler {
                        list = answerList
                    }
                    DispatchQueue.main.async {
                        completion(list)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - Save orders
    final class func addCart(yemek_adi: String, yemek_fiyat: String, yemek_resim_adi: String, yemek_siparis_adet: String, kullanici_adi: String) {
        let params : Parameters = ["yemek_adi" : yemek_adi, "yemek_fiyat" : yemek_fiyat, "yemek_siparis_adet" : yemek_siparis_adet, "yemek_resim_adi" : yemek_resim_adi, "kullanici_adi" : "\(User.currentId())"]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters : params).response{
            response in
            if let data = response.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(json)
                    }
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - To get food added to cart
    final class func getCart(_ completion: @escaping([FoodInTheCart]) -> Void){
        let param : Parameters = ["kullanici_adi" : "\(User.currentId())"]
        
        AF.request(kGETCARTLINK, method: .post, parameters: param).response { response in
            if let data = response.data {
                do {
                    let answer = try JSONDecoder().decode(FoodInTheCartResponse.self, from: data)
                    var list = [FoodInTheCart]()
                    if let answerList = answer.sepet_yemekler {
                        list = answerList
                    }
                    DispatchQueue.main.async {
                        completion(list)
                    }
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - To delete the food in the cart
    final class func deleteCart(cart: FoodInTheCart, userId: String) {
        let params: Parameters = ["sepet_yemek_id" : cart.sepet_yemek_id!, "kullanici_adi" : User.currentId() ]
        AF.request(kDELETECART, method: .post, parameters: params).response { response in
            if let data = response.data {
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(json)
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    //MARK: - To delete all the foods in the basket
    final class func deleteAllCart(carts: [FoodInTheCart]) {
        for cart in carts {
                deleteCart(cart: cart, userId: User.currentId())
        }
    }
}
