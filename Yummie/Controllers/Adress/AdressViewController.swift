//
//  AdressViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.06.2022.
//

import UIKit

class AdressViewController: UIViewController {
    

    //MARK: - IBOutlets
    @IBOutlet weak var adressTableView: UITableView!
    
    //MARK: - Vars
    var adressList = [Adress]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerCells()
        getAdress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    //MARK: Connection of cell design
    private func registerCells() {
        adressTableView.register(UINib(nibName: AdressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdressTableViewCell.identifier)
    }
    
    //MARK: - To get all addresses from firebase
    private func getAdress() {
        downloadAdressFromFirebase(with: User.currentId()) { (allAdress) in
            self.adressList = allAdress
            self.adressTableView.reloadData()
            print("kaç tane \(self.adressList.count)")
        }
    }
    
    //MARK: - To update the selected address as the user address
    private func updateSelectedUserAdress(_ adressDict: [String:Any]) {
        updateUserAdressInFirebase(withValues: adressDict) { (error) in
            if error == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK: - Delete adress from firebase
    private func deleteAdress(_ adress: Adress){
        deleteAdressToFirebase(with: adress.adressId!)
    }
    
    private func adressControl() {
        if adressList.count == 0 {
            let adressString = "Görüntülenecek adres yok"
            let adressDict = [kFULLADRESS : adressString] as [String:Any]
            updateSelectedUserAdress(adressDict)
        }
    }
}

extension AdressViewController: UITableViewDelegate,UITableViewDataSource,TrashProtocol{
    func deleteAdressProtocolFunc(indexPath: IndexPath) {
        deleteAdress(adressList[indexPath.row])
        adressList.remove(at: indexPath.row)
        adressControl()
        adressTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adress = adressList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AdressTableViewCell.identifier) as! AdressTableViewCell
        let adressString = "\(adress.bourhood), \(adress.street), No:\(adress.homeNumber), Kat:\(adress.floorNumber), Apart No:\(adress.apartNumber)"
        cell.setup(adressString)
        cell.indexPath = indexPath
        cell.trashProtocol = self
        print("AdressId: \(adress.adressId!)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adress = adressList[indexPath.row]
        let adressString = "\(adress.bourhood), \(adress.street), No:\(adress.homeNumber), Kat:\(adress.floorNumber), Apart No:\(adress.apartNumber)"
        let adressDict = [kFULLADRESS : adressString] as [String:Any]
        updateSelectedUserAdress(adressDict)
    }
}
