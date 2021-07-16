//
//  LoginPageViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/09.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class LoginPageViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    @IBOutlet weak var appleLoginImageView: UIImageView!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    // firebase
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    let tabBarViewController = MainTabBarController() // 임시로 지정
    
    // MARK: - IBAction
    @IBAction func touchUpSignUpButton(_ sender: UIButton) {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc func loginEvent() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                self.displayLoginOrSignUpFormatAlert()
                
                self.passwordTextField.text = nil
            } else {
                self.view.window?.switchRootViewController(self.tabBarViewController)
            }
        }
    }
    
    @objc func findAndUpdatePasswordEvent() {
        let forgotAndUpdatePasswordVC = ForgotAndUpdatePasswordViewController()
        forgotAndUpdatePasswordVC.color = self.color
        
        self.present(forgotAndUpdatePasswordVC, animated: true, completion: nil)
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(findAndUpdatePasswordEvent), for: .touchUpInside)
    }
    
    // MARK: - Custom Methods
    func initProperties() {
        color = remoteConfig["splash_background"].stringValue
        
        // 오토레이아웃, 모양 및 이미지, 색 지정
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "cocktail")
        
        setTextFieldLayout(textField: emailTextField, title: "Email")
        setTextFieldLayout(textField: passwordTextField, title: "Password")
        
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(hex: color)
        loginButton.tintColor = .white
        
        kakaoLoginImageView.image = #imageLiteral(resourceName: "loginLogo_kakao")
        appleLoginImageView.image = #imageLiteral(resourceName: "loginLogo_apple")
    }
    
    func setTextFieldLayout(textField: SkyFloatingLabelTextField, title: String, color: String = "system") {
        textField.title = title
        
        textField.lineColor = .lightGray
        
        if color != "system" {
            textField.tintColor = UIColor(hex: color)
            textField.selectedTitleColor = UIColor(hex: color)
            textField.selectedLineColor = UIColor(hex: color)
        }
        
        textField.errorColor = .red

        textField.lineHeight = 1.0
        textField.selectedLineHeight = 2.0
    }
    
    func displayLoginOrSignUpFormatAlert() {
        let alert = UIAlertController(title: "실패", message: "이메일/비밀번호를 확인해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
