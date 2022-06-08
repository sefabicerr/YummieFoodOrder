//
//  LogInViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 22.04.2022.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView


class LogInViewController: UIViewController, AlertProtocol,ActivityIndicatorProtocol{

    //MARK: - IBOutlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var segmented: UISegmentedControl! {
        didSet{
            segmented.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    //MARK: - VARS
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = createActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
        
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
    
    @IBAction func logInBtnClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
                    alertMessage(titleInput: "Hata",
                                 messageInput: "Email ya da şifre alanı boş olamaz. Lütfen kontrol ediniz.")
                return
        }
        loginUser()
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: Any) {
        if emailTextField.text != "" {
            resetThePassword()
        } else {
            alertMessage(titleInput: "Hata", messageInput: "Lütfen email adresinizi giriniz.")
        }
    }
    
    @IBAction func segmentedBtn(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SingUpViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Helpers
    private func textFieldHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func resetThePassword(){
        User.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil {
                self.alertMessage(titleInput: "Başarılı", messageInput: "Şifre yenileme maili gönderildi.")
            } else {
                let error = error?.localizedDescription
                self.alertMessage(titleInput: "Başarısız", messageInput: error!)
            }
        }
    }
    
    //MARK: Login User
    private func loginUser() {
        showLoadingIndicator(activityIndicator: activityIndicator)
        User.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in

            if error == nil {
                if isEmailVerified {
                    print("mail doğrulanmış")
                    self.goToHomeView()
                } else {
                    self.alertMessage(titleInput: "Email Doğrulama Hatası",
                                      messageInput: "Email doğrulanmamış. lütfen mailinize gönderilen doğrulama linkine tıklayın.")
                }
            } else {
                self.alertMessage(titleInput: "Giriş Hatası",
                                  messageInput: "Girilen email ya da şifre hatalı. Lütfen kontrol ediniz.")
            }
        }
        self.hideLoadingIndicator(activityIndicator: self.activityIndicator)
    }
    
    //MARK: Go to homeview
    private func goToHomeView() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        print("girdin mesajı ve yönlendirme")
    }
}
