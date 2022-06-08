//
//  EditProfileTableViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 2.05.2022.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, AlertProtocol {
    
    //MARK:IBOutlets
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            nameTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var surnameTextField: UITextField!{
        didSet{
            surnameTextField.tag = 2
            surnameTextField.delegate = self
            surnameTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var phoneNumberTextField: UITextField!{
        didSet{
            phoneNumberTextField.tag = 3
            phoneNumberTextField.delegate = self
            phoneNumberTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var adressTextField: UITextField!{
        didSet{
            adressTextField.tag = 3
            adressTextField.delegate = self
            adressTextField.autocapitalizationType = .words
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0)
        loadUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if textFieldHaveText() {
            finishOnBoarding()
        } else {
            alertMessage(titleInput: "Hata", messageInput: "Email ya da şifre alanı boş olamaz. Lütfen kontrol ediniz.")
        }
    }
    
    private func finishOnBoarding() {
        let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME: surnameTextField.text!, kONBOARD : true, kFULLADRESS : adressTextField.text!, kPHONENUMBER : phoneNumberTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!)] as [String:Any]
        
        updateCurrentUserInFirebase(withValues: withValues) { (error) in
            if error == nil {
                self.alertMessage(titleInput: "Başarılı", messageInput: "Düzenleme işlemi başarılı.") { action in
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.alertMessage(titleInput: "Hata", messageInput: error!.localizedDescription)
            }
        }
    }
    
    private func loadUserInfo() {
        guard let user = User.currentUser() else { return }
        nameTextField.text = user.firsName
        surnameTextField.text = user.lastName
        phoneNumberTextField.text = user.phoneNumber
        adressTextField.text = user.fullAdress
    }
    
    private func textFieldHaveText() -> Bool {
        return (nameTextField.text != "" && surnameTextField.text != "" && phoneNumberTextField.text != "" && adressTextField.text != "")
    }
}