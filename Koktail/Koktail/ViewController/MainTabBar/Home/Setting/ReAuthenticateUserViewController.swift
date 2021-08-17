//
//  ReAuthenticateUserViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/09.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ReAuthenticateUserViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var checkPasswordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var color: String!
    let remoteConfig = RemoteConfig.remoteConfig()
    
    // MARK: - Actions
    @objc private func cancelEvent() {
        self.dismiss(animated: true)
    }
    
    @objc private func showDeleteAlertEvent() {
        if self.isEveryInformationCorrect() == false {
            print("입력 정보 부족")
            self.showUserInfoNotCorrectAlert()
        } else {
            let alert = UIAlertController(title: "안내",
                                          message: "콕테일에 저장된 모든 정보를 삭제하고 탈퇴하시겠습니까?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "네",
                                          style: .default) { _ in
                                            self.requestDeleteAccount()
                                          })
            alert.addAction(UIAlertAction(title: "취소",
                                          style: .cancel,
                                          handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: Networking
    private func requestDeleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("User Not Exist")
            return
        }
        
        user.delete(completion: { error in
            if let error = error {
                print("Cannot delete user")
                print(error.localizedDescription)
                
                // 유저 재인증
                let credential: AuthCredential = EmailAuthProvider.credential(
                    withEmail: UserDefaultsManager.userId,
                    password: self.passwordTextField.text!)
                
                user.reauthenticate(with: credential) { authResult, error in
                    if let error = error {
                        print("Cannot reauthenticate user")
                        print(error.localizedDescription)
                        
                        self.showUserInfoNotCorrectAlert()
                        return
                    }
                    
                    authResult?.user.delete(completion: { error in
                        if let error = error {
                            print("Really cannot delete...")
                            print(error.localizedDescription)
                            
                            self.showUserInfoNotCorrectAlert()
                            return
                        }
                        
                        print("Finally delete current user!")
                        self.deleteAccountAPI()
                    })
                }
            }
            
            print("Delete current user---> check Firebase Auth")
            self.deleteAccountAPI()
        })
    }
    
    private func deleteAccountAPI() {
        let token = UserDefaultsManager.token
        guard let url = URL(string: "http://3.36.149.10:55670/api/user/delete?token=\(token)") else {
            print("Cannot create url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("cannot send urlRequest")
                print(error.localizedDescription)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                guard let object = jsonObject else {
                    print("jsonObject is nil")
                    return
                }
                
                let code = object["code"] as? Int
                let message = object["message"] as? String
                
                print("회원탈퇴: \(code!): \(message!)")
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
        UserDefaultsManager.userId = ""
        UserDefaultsManager.token = ""
        UserDefaultsManager.social = ""
        
        guard let window = self.view.window else {
            return
        }
        
        window.switchRootViewController(LoginViewController())
    }
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        self.deleteAccountButton.addTarget(self,
                                           action: #selector(showDeleteAlertEvent),
                                           for: .touchUpInside)
        self.cancelButton.addTarget(self,
                                    action: #selector(cancelEvent),
                                    for: .touchUpInside)
    }
    
    // MARK: - Set properties
    private func initProperties() {
        self.color = remoteConfig["splash_background"].stringValue
        
        deleteAccountButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        deleteAccountButton.backgroundColor = UIColor(hex: color)
        cancelButton.backgroundColor = UIColor(hex: color)
        
        setTextFieldLayout(textField: emailTextField, title: "Email")
        setTextFieldLayout(textField: passwordTextField, title: "Password")
        setTextFieldLayout(textField: checkPasswordTextField, title: "Confirm Password")
    }
    
    private func setTextFieldLayout(textField: SkyFloatingLabelTextField, title: String, color: String = "system") {
        textField.title = title
        textField.placeholder = title
        
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
    
    // MARK: - Custom Methods
    private func isEveryInformationCorrect() -> Bool {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let checkPassword = checkPasswordTextField.text {
            
            if email == "" ||
                password == "" ||
                checkPassword == "" {
                return false
            }
            
            if email != UserDefaultsManager.userId {
                return false
            }
            
            if password != checkPassword {
                return false
            }
            
            // 유저 이메일에 따른 비밀번호 확인
            var canSignIn: Bool = true
            Auth.auth().signIn(withEmail: email,
                               password: password) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showUserInfoNotCorrectAlert()
                    canSignIn = false
                }
            }
            
            return canSignIn
        }
        
        return true
    }
    
    private func showUserInfoNotCorrectAlert() {
        let alert = UIAlertController(title: "안내",
                                      message: "입력하신 정보를 확인해주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인",
                                      style: .default,
                                      handler: nil))
        
        self.present(alert, animated: true)
    }
}
