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
                                        
                                        displayLoginOrSignUpFormatAlert()
                                        self.emailTextField.text = ""
                                        
                                        return
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
                                UserDefaultsManager.userId = email
                                
                                postSignUpInformation()
                            }
                        }
                        
                        UserDefaultsManager.userId = email
                        UserDefaultsManager.social = "kakao"
                        
                        self.view.window?.switchRootViewController(self.tabBarViewController)
                    }
                }
            } else {
                displayLoginOrSignUpFormatAlert()
            }
        }
    }
    
    @objc func cancelEvent() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        okButton.addTarget(self, action: #selector(okEvent), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
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
    
    func displayLoginOrSignUpFormatAlert() {
        let alert = UIAlertController(title: "실패",
                                      message: "이메일을 확인해주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func postSignUpInformation() {
        let email = UserDefaultsManager.userId
        let token = UserDefaultsManager.token
        
        let param = ["email": email, "token": token]
        let paramData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: "http://3.35.50.183:55097/api/user/signup") else {
            print("CANNOT CREATE URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        
        // HTTP message header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // 응답 처리
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else {
                        return
                    }
                    
                    // JSON 결과값 확인
                    let code = jsonObject["code"] as? Int
                    let message = jsonObject["message"] as? String
                    
                    print("CODE: \(code!), MESSAGE: \(message!)")
                    
                } catch let error as NSError {
                    print("ERROR WHILE PARSING JSONObject : \(error.localizedDescription)")
                }
            }
        }
        
        task.resume() // post 전송
    }
}
