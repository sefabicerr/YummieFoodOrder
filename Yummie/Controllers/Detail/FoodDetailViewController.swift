//
//  FoodDetailViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 14.05.2022.
//

import UIKit
import Kingfisher

class FoodDetailViewController: UIViewController, AlertProtocol {
    
    //MARK: IBOutlets
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var foodImageLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    
    
    //MARK: VARS
    var food: Foods?
    var favFood = [Favorites]()
    var count = 1
    var isImageClick = false
    var cartImage: [UIImage?] = []
    var imageView = UIImageView()
    let d = UserDefaults.standard
    var dictList: [String:String] = [:]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIInfo()
        createGestureRecognizer()
        
        //getFavorite()
        //print(isImageClick)
        getFavorite2()

        
    }
    
    
    private func createGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage(tapGestureRecognizer:)))
        favImage.isUserInteractionEnabled = true
        favImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func changeImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if isImageClick {
            deleteFavorite()
            isImageClick = false
            tappedImage.image = UIImage(systemName: "heart")
            
        } else {
            saveToFirebase()
            isImageClick = true
            tappedImage.image = UIImage(systemName: "heart.fill")
        }
    }
    
    //MARK: To save favorite food in firebase
    private func saveToFirebase() {
        
        if let food = food {
            print(food.yemek_id!)
            let fav = Favorites(foodId:food.yemek_id!,
                                userId: User.currentId(),
                                foodName: food.yemek_adi!,
                                foodPrice: food.yemek_fiyat!/*, imageLink: imageList*/)
            self.imageView.kf.setImage(with: "\(kGETALLIMAGESLINK)\(food.yemek_resim_adi!)".asUrl)
            self.cartImage.append(self.imageView.image)
            
            uploadImages(images: cartImage, itemId: fav.foodId) { (imageLinkArray) in
                fav.imageLink = imageLinkArray
                saveFavoriteToFirebase(favorite: fav)
                self.d.set(fav.favId, forKey: fav.foodId)
                
            }
        }
    }
    
    private func getFavorite2() {
        let favoriteId = d.string(forKey: food!.yemek_id!)
        
        if favoriteId != nil {
            downloadItemsWithIdFromFirebase(with: User.currentId(), with: favoriteId!) { (response) in
                print(response)
                self.isImageClick = response
                self.favImage.image = UIImage(systemName: "heart.fill")
                print(self.isImageClick)
            }
        }
    }
    
    private func deleteFavorite(){
        let favoriteId = d.string(forKey: food!.yemek_id!)
        deleteToFirebase(with: favoriteId!)
        d.removeObject(forKey: food!.yemek_id!)
    }
    
    
    @IBAction func cartBtnClicked(_ sender: Any) {
        if let food = food {
            Service.addCart(yemek_adi: food.yemek_adi!, yemek_fiyat: food.yemek_fiyat!, yemek_resim_adi: food.yemek_resim_adi!, yemek_siparis_adet: String(count), kullanici_adi: User.currentId())
            alertMessage(titleInput: "Başarılı", messageInput: "\(food.yemek_adi!) sepete eklendi") { action in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func plusBtnClicked(_ sender: Any) {
        toIncrease()
    }
    
    @IBAction func minusBtnClicked(_ sender: Any) {
        toDecrease()
    }
    
    //MARK: For setup ui info
    private func setupUIInfo () {
        if let food = food {
            foodImageLbl.text = food.yemek_adi
            foodPriceLbl.text = "₺\(food.yemek_fiyat!).00"
            
            DispatchQueue.main.async {
                self.foodImage.kf.setImage(with: "\(kGETALLIMAGESLINK)\(food.yemek_resim_adi!)".asUrl)
            }
        }
    }
    
    //MARK: To increase the number of food orders
    private func toIncrease() {
        if count >= 1 && count < 20 {
            count += 1
        }
        countLbl.text = "\(count)"
        
        if let food = food {
            let dataPrice = Int(food.yemek_fiyat!)
            foodPriceLbl.text = "₺\(dataPrice! * count).00"
        }
    }
    
    //MARK: To decrease the number of food orders
    private func toDecrease() {
        if count > 1 && count <= 20 {
            count -= 1
        }
        countLbl.text = "\(count)"
        
        if let food = food {
            let dataPrice = Int(food.yemek_fiyat!)
            foodPriceLbl.text = "₺\(dataPrice! * count).00"
        }
    }
}
