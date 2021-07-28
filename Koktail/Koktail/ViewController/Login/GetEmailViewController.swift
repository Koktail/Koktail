//
//  GetEmailViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/22.
//

import UIKit
import SkyFloatingLabelTextField

import FirebaseAuth
import KakaoSDKUser

class GetEmailViewController: UIViewController {

    // MARK: - Properties
    var color: String = "system"
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let tabBarViewController = MainTabBarController()
    
    // MARK: - Action
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if text.count < 3 || !text.contains("@") {
                    floatingLabelTextField.errorMessage = "잘못된 이메일 형식입니다."
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    /// 카카오톡으로 로그인한 정보를 파이어베이스에 등록
    @objc func okEvent() {
        if let email = emailTextField.text {
            if isValidEmail(email: email) {
                UserApi.shared.me { [self] kakaoUser, error in
                    if let error = error {
                        print("< KAKAO: user loading failed >")
                        print(error.localizedDescription)
                    } else {
                        guard let password = kakaoUser?.id else {
                            return
                        }
                        
                        Auth.auth().createUser(withEmail: email,
                                               password: String(describing: password)) {user, error in
                            if let error = error {
                                print("< FIREBASE: signUp failed >")
                                print(error.localizedDescription)
                                
                                Auth.auth().signIn(withEmail: email,
                                                   password: String(describing: password)) { signInUser, signInError in
                                    if let signInError = signInError {
                                        print("< FIREBASE: signIn failed >")
                                        print(signInError.localizedDescription)
                                    } else {
                                        print(" < FIREBASE: signIn success >")
                                        
                                        guard let token = signInUser?.user.uid else {
                                            print("no firebase uid")
                                            return
                                        }
                                        UserDefaultsManager.token = token
                                    }
                                }
                            } else {
                                print("< FIREBASE: signup success >")
                                
                                guard let token = user?.user.uid else {
                                    print("no firebase uid")
                                    return
                                }
                                UserDefaultsManager.token = token
                            }
                        }
                        
                        UserDefaultsManager.userId = email
                        UserDefaultsManager.social = "kakao"
                        self.view.window?.switchRootViewController(self.tabBarViewController)
                    }
                }
            }
        }
    }
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        okButton.addTarget(self, action: #selector(okEvent), for: .touchUpInside)
    }
    
    // MARK: - Custom Method
    func isValidEmail(email: String) -> Bool {
        if email == "" {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    func initProperties() {
        okButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        okButton.backgroundColor = UIColor(hex: color)
        cancelButton.backgroundColor = UIColor(hex: color)
        
        emailTextField.title = "Email"
        
        emailTextField.lineColor = .lightGray
        emailTextField.errorColor = .red

        emailTextField.lineHeight = 1.0
        emailTextField.selectedLineHeight = 2.0
    }
}
