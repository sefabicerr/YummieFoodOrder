//
//  CampaignViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.06.2022.
//

import UIKit

class CampaignViewController: UIViewController,AlertProtocol {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -Vars
    var discount = 20
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        registerCells()
    }
    
    //MARK: -Connection of cell design
    private func registerCells() {
        tableView.register(AddCodeTableViewCell.nib(), forCellReuseIdentifier: AddCodeTableViewCell.identifier)
        tableView.register(NoCodeTableViewCell.nib(), forCellReuseIdentifier: NoCodeTableViewCell.identifier)
    }
    
    //MARK: - Campaign code validity check func
    private func codeValidityCheck(_ code: String) -> Bool {
        if code == "sefa" {
            NotificationCenter.default.post(name: NSNotification.Name("discount"), object: nil)
            navigationController?.popViewController(animated: true)
            return true
        } else {
            return false
        }
    }
}

extension CampaignViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCodeTableViewCell.identifier, for: indexPath) as! AddCodeTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoCodeTableViewCell.identifier, for: indexPath) as! NoCodeTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            alertWithTextField(titleInput: "Kampanya Kodu", placeHolder: "Kampanya kodu yazınız") { (textField) in
                let isValidCode = self.codeValidityCheck(textField)
                print(isValidCode)
            }
        } else {
            navigationController?.popViewController(animated : true)
        }
    }
}
