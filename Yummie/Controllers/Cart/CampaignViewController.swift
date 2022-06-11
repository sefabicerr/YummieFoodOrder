//
//  CampaignViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.06.2022.
//

import UIKit

class CampaignViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    //MARK: -Connection of cell design
    private func registerCells() {
        tableView.register(AddCodeTableViewCell.nib(), forCellReuseIdentifier: AddCodeTableViewCell.identifier)
        tableView.register(NoCodeTableViewCell.nib(), forCellReuseIdentifier: NoCodeTableViewCell.identifier)
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
            
        } else {
            navigationController?.popViewController(animated : true)
        }
    }
}
