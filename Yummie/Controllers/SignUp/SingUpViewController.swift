//
//  SingUpViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 22.04.2022.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SingUpViewController: UIViewController,AlertProtocol{

    
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
    var iconClick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showHidePasswordView()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: UIColor(named: "IndicatorColor") /*#colorLiteral(red:0.9998469946 , green:1.0 , blue:1.0 , alpha:1.0)*/, padding: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmented.selectedSegmentIndex = 1
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
    
    private func registerUser() {
        showLoadingIndicator()
        
        User.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil {
                self.alertMessage(titleInput: "Kayıt Başarılı", messageInput: "Kayıt tamamlandı. Doğrulama maili gönderildi") { action in
                    self.goToLogin()
                }
            } else {
                print("error:", error!.localizedDescription)
                self.alertMessage(titleInput: "Hata", messageInput: "Email adresi zaten başka bir hesap tarafından kullanılıyor, lütfen başka bir hesap kullanın.")
            }
            self.hideLoadingIndicator()
        }
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
