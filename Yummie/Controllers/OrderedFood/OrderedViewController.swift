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
        orderedTableView.backgroundView = EmptyView.emptyViewObj
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrderedDetail" {
            let ordered = sender as? Ordered
            let VC = segue.destination as! OrderedDetailViewController
            VC.ordered = ordered
        }
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
    
    //MARK: - Delete ordered from firebase
    private func deleteOrdered(_ ordered: Ordered){
        deleteOrderedToFirebase(with: ordered.orderedId!)
    }
}


extension OrderedViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if orderedList.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
            EmptyView.viewSetup("Geçmiş siparişiniz yok", "empty-ordered")
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderedTableViewCell.identifier) as! OrderedTableViewCell
        let ordered = orderedList[indexPath.row]
        cell.setup(ordered: ordered)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ordered = orderedList[indexPath.row]
        performSegue(withIdentifier: "toOrderedDetail", sender: ordered)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (contextualAction,view,boolValue) in
            let ordered = self.orderedList[indexPath.row]
            self.deleteOrdered(ordered)
            DispatchQueue.main.async {
                self.orderedList.remove(at: indexPath.row)
                self.orderedTableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}
