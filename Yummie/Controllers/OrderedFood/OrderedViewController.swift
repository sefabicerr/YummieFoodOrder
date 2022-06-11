//
//  OrderedViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 31.05.2022.
//

import UIKit

class OrderedViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var orderedTableView: UITableView!
    
    //MARK: - Vars
    var orderedList = [Ordered]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        getOrdered()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: Connection of cell design
    private func registerCells() {
        orderedTableView.register(UINib(nibName: OrderedTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderedTableViewCell.identifier)
    }
    
    //MARK: - Get from all ordered from firebase
    private func getOrdered() {
        downloadOrderedFromFirebase(with: User.currentId()) { (allOrdered) in
            self.orderedList = allOrdered
            self.orderedTableView.reloadData()
            print(self.orderedList.count)
        }
    }
}


extension OrderedViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderedTableViewCell.identifier) as! OrderedTableViewCell
        let ordered = orderedList[indexPath.row]
        cell.setup(ordered: ordered)
        return cell
    }
    
    
    
}
