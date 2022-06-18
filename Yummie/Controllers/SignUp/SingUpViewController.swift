//
//  SingUpViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 22.04.2022.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SingUpViewController: UIViewController,AlertProtocol,ActivityIndicatorProtocol{

    
    @IBOutlet weak var segmented: UISegmentedControl! {
        didSet {
            segmented.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var passwordVerificationTextField: UITextField! {
        didSet {
            passwordVerificationTextField.isSecureTextEntry = true
        }
    }
    
    //MARK: Vars
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = createActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmented.selectedSegmentIndex = 1
    }
    
    @IBAction func showPasswordBtnClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            passwordTextField.isSecureTextEntry = true
        } else {
            sender.isSelected = true
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    @IBAction func showPasswordVerificationBtnClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            passwordVerificationTextField.isSecureTextEntry = true
        } else {
            sender.isSelected = true
            passwordVerificationTextField.isSecureTextEntry = false
        }
    }

    @IBAction func signUpBtnClicked(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" || passwordVerificationTextField.text == "" {
            alertMessage(titleInput: "Hata", messageInput: "Email ya da şifre alanı boş olamaz. Lütfen kontrol ediniz.")
        } else if passwordTextField.text != passwordVerificationTextField.text {
            alertMessage(titleInput: "Şifre Doğrulama Hatası", messageInput: "Şifreler uyuşmuyor. Lütfen kontrol ediniz.")
        } else {
            registerUser()
        }
    }
    
    //MARK: For signup screen to login screen
    func goToLogin(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func segmentedBtn(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            goToLogin()
        }
    }
    
    //MARK: - To save user to firebase
    private func registerUser() {
        showLoadingIndicator(activityIndicator: activityIndicator)
        
        User.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil {
                self.alertMessage(titleInput: "Kayıt Başarılı", messageInput: "Kayıt tamamlandı. Doğrulama maili gönderildi") { action in
                    self.goToLogin()
                }
            } else {
                print("error:", error!.localizedDescription)
                self.alertMessage(titleInput: "Hata", messageInput: "\(error!.localizedDescription)")
            }
            self.hideLoadingIndicator(activityIndicator: self.activityIndicator)
        }
    }
}
