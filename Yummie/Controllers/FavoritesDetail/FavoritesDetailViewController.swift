//
//  FavoritesDetailViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 13.06.2022.
//

import UIKit

class FavoritesDetailViewController: UIViewController,AlertProtocol {

    //MARK: IBOutlets
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var foodImageLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    //MARK: -Vars
    var food: Favorites?
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGestureRecognizer()
        setupUIInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Haydaaaaaaaaaaaa\(food!.imageLinkName!)")
    }
    
    private func createGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteFav(tapGestureRecognizer:)))
        favImage.isUserInteractionEnabled = true
        favImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func deleteFav(tapGestureRecognizer: UITapGestureRecognizer) {
        deleteFavorite()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func deleteFavorite(){
        let favoriteId = food?.favId
        deleteToFirebase(with: favoriteId!)
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func cartBtnClicked(_ sender: Any) {
        if let food = food {
            Service.addCart(yemek_adi: food.foodName, yemek_fiyat: food.foodPrice, yemek_resim_adi: food.imageLinkName!, yemek_siparis_adet: String(count), kullanici_adi: User.currentId())
            alertMessage(titleInput: "Başarılı", messageInput: "\(food.foodName) sepete eklendi") { action in
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
            foodImageLbl.text = food.foodName
            foodPriceLbl.text = "₺\(food.foodPrice).00"
            if food.imageLink != nil && food.imageLink.count > 0 {
                downloadImages(imageUrls: [food.imageLink.first!]) { (images) in
                    self.foodImage.image = images.first as? UIImage
                }
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
            let dataPrice = Int(food.foodPrice)
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
            let dataPrice = Int(food.foodPrice)
            foodPriceLbl.text = "₺\(dataPrice! * count).00"
        }
    }
    
    
}
