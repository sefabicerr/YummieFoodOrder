//
//  CartViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 16.05.2022.
//

import UIKit

class CartViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    //MARK: Vars
    var foodList = [FoodInTheCart]()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getFood()
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
        if foodList.count > 0{
            let order = Ordered(userId: User.currentId(), totalPrice: priceLabel.text!, adress: User.currentUser()!.fullAdress!)
            performSegue(withIdentifier: "toPlaceAnOrder", sender: order)
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
    
    //MARK: - Function of calculates the total price
    func totalPriceCalculator(cardList: [FoodInTheCart]) {
        var totalPrice = 0
        for price in cardList {
            totalPrice = totalPrice + (Int(price.yemek_fiyat ?? "0")! * Int(price.yemek_siparis_adet ?? "0")!)
            print(price.yemek_fiyat!)
        }
        priceLabel.text = "₺\(totalPrice).00"
    }  
}

//MARK: Create datasource and delegate func
extension CartViewController: UITableViewDelegate,UITableViewDataSource {
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
