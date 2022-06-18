//
//  CartViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 16.05.2022.
//

import UIKit

class CartViewController: UIViewController,AlertProtocol {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    @IBOutlet weak var cardView: CardView!
    //MARK: Vars
    var foodList = [FoodInTheCart]()
    var totalPrice = ""
    var adressList = [Adress]()
    var emptyView = EmptyView()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        getFood()
        tableView.backgroundView = emptyView
        getAdress()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllCart), name: NSNotification.Name.init(rawValue: "deleteCartList"), object: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlaceAnOrder" {
            let order = sender as? Ordered
            let VC = segue.destination as! PlaceAnOrderViewController
            VC.order = order
        }
    }
    
    //MARK: - Order button func
    @IBAction func orderBtnClicked(_ sender: Any) {
        if foodList.count > 0 && adressList.count > 0 && minimumOrderPrice(cardList: foodList){
            let order = Ordered(userId: User.currentId(), totalPrice: totalPrice, adress: User.currentUser()!.fullAdress!)
            performSegue(withIdentifier: "toPlaceAnOrder", sender: order)
        } else {
            alertMessage(titleInput: "Adres yok", messageInput: "Sipariş verebilmek için kayıtlı adresinizin olması gerekmektedir,lütfen adres ekleyiniz.")
        }
    }
    
    //MARK: - Trash button func
    @IBAction func trashBtnClicked(_ sender: Any) {
        deleteAllCart()
    }
    
    
    //MARK: - To delete all the food in the cart
    @objc func deleteAllCart() {
        Service.deleteAllCart(carts: foodList)
        DispatchQueue.main.async {
            self.foodList.removeAll()
            self.totalPriceCalculator(cardList: self.foodList)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Connection of cell design
    private func registerCells() {
        tableView.register(UINib(nibName: CartTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CartTableViewCell.identifier)
    }
    
    //MARK: - Func of displaying the orders from the service in the table view
    private func getFood(){
        Service.getCart() { response in
            self.foodList = response
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.totalPriceCalculator(cardList: self.foodList)
            }
        }
    }
    
    //MARK: - Minimum order price control func
    private func minimumOrderPrice(cardList: [FoodInTheCart]) -> Bool {
        var totalPrice = 0
        for price in cardList {
            totalPrice = totalPrice + (Int(price.yemek_fiyat ?? "0")! * Int(price.yemek_siparis_adet ?? "0")!)
        }
        if totalPrice < 20 {
            alertMessage(titleInput: "Uyarı", messageInput: "Minimum sipariş tutarı ₺20'dir")
            return false
        } else {
            return true
        }
    }
    
    //MARK: - Function of calculates the total price
    func totalPriceCalculator(cardList: [FoodInTheCart]){
        var totalPrice = 0
        for price in cardList {
            totalPrice = totalPrice + (Int(price.yemek_fiyat ?? "0")! * Int(price.yemek_siparis_adet ?? "0")!)
            print(price.yemek_fiyat!)
        }
        priceLabel.text = "₺\(totalPrice).00"
        self.totalPrice = "\(totalPrice)"
    }
    
    //MARK: - To get all addresses from firebase
    private func getAdress() {
        downloadAdressFromFirebase(with: User.currentId()) { (allAdress) in
            self.adressList = allAdress
            print("kaç tane \(self.adressList.count)")
        }
    }
}

//MARK: Create datasource and delegate func
extension CartViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if foodList.count > 0 {
            cardView.isHidden = false
            tableView.backgroundView?.isHidden = true
        } else {
            cardView.isHidden = true
            tableView.backgroundView?.isHidden = false
            emptyView.nameLbl.text = "Sepetiniz boş"
            emptyView.imageView.image = UIImage(named: "empty-cart")
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        cell.setup(foodList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (contextualAction,view,boolValue) in
            let cart = self.foodList[indexPath.row]
                Service.deleteCart(cart: cart, userId: User.currentId())
            DispatchQueue.main.async {
                self.foodList.remove(at: indexPath.row)
                self.totalPriceCalculator(cardList: self.foodList)
                self.tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
