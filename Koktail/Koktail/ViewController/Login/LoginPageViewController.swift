//
//  LoginPageViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/09.
//

import UIKit
import TextFieldEffects
import Firebase

class LoginPageViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var kakaoLoginImageView: UIImageView!
    @IBOutlet weak var appleLoginImageView: UIImageView!
    
    // firebase
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    let tabBarViewController = MainTabBarController() // 임시로 지정
    
    // MARK: - IBAction
    @IBAction func touchUpSignUpButton(_ sender: UIButton) {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
    }
    
    // MARK: - Custom Methods
    func initProperties() {
        color = remoteConfig["splash_background"].stringValue
        
        // 오토레이아웃, 모양 및 이미지, 색 지정
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "cocktail")

        emailTextField.borderInactiveColor = UIColor(hex: color)
        passwordTextField.borderInactiveColor = UIColor(hex: color)
        
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(hex: color)
        loginButton.tintColor = .white
        
        kakaoLoginImageView.image = #imageLiteral(resourceName: "loginLogo_kakao")
        appleLoginImageView.image = #imageLiteral(resourceName: "loginLogo_apple")
    }

    @objc func loginEvent() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                let alert = UIAlertController(title: "Error",
                                              message: "아이디/비밀번호를 확인해주세요.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                // 커서 없애는 방법?
            } else {
                UserDefaultsManager.userId = email
                self.view.window?.switchRootViewController(self.tabBarViewController)
            }
        }
    }
    
}
