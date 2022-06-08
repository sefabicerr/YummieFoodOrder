//
//  LogInViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 22.04.2022.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView


class LogInViewController: UIViewController, AlertProtocol{


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.enablePasswordToggle()
        }
    }
    @IBOutlet weak var segmented: UISegmentedControl! {
        didSet{
            segmented.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    
    //MARK: VARS
    var activityIndicator: NVActivityIndicatorView?
    var iconClick = false
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: UIColor(named: "IndicatorColor"), padding: nil)
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
    
    //MARK: Activity Indicator
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    
    //MARK: Login User
    private func loginUser() {
        showLoadingIndicator()
        
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
            self.hideLoadingIndicator()
        }
    }
    
    //MARK: Go to homeview
    private func goToHomeView() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        print("girdin mesajı ve yönlendirme")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Show/Hide Password func
    func showHidePasswordView() {
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(named: "hidden")
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageIcon.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        passwordTextField.rightView = contentView
        passwordTextField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if iconClick{
            iconClick = false
            tappedImage.image = UIImage(named: "view")
            passwordTextField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImage.image = UIImage(named: "hidden")
            passwordTextField.isSecureTextEntry = true
        }
    }
}


