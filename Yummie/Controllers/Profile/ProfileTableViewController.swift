//
//  ProfileTableViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 1.05.2022.
//

import UIKit
import FirebaseAuth

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    
    //MARK: -Vars
    @IBOutlet weak var rightEditBtn: UIBarButtonItem!
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        self.clearsSelectionOnViewWillAppear = true

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkOnBoardingStatus()
       
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            logOut()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileTableViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .partialCurl
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: - User logs out
    private func logOut() {
        do{
            try Auth.auth().signOut()
            let controller = storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .partialCurl
            present(controller, animated: true, completion: nil)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private func checkOnBoardingStatus() {
        if User.currentUser()!.onBoard {
            userInfoInLabel()
        } else {
            defaultUserInfoInLabel()
        }
    }
    
    private func defaultUserInfoInLabel() {
        fullNameLbl.text = "My Name"
        phoneNumberLbl.text = "My Phone Number"
        adressLbl.text = "My Adress"
    }
    
    private func userInfoInLabel() {
        guard let user = User.currentUser() else { return }
        fullNameLbl.text = user.fullName
        phoneNumberLbl.text = user.phoneNumber
        adressLbl.text = user.fullAdress
    }
}

