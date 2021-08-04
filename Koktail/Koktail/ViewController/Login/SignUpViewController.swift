//
//  SignUpViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/12.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class SignUpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var checkPasswordTextField: SkyFloatingLabelTextField!
    
    var color: String!
    
    // Firebase
    let remoteConfig = RemoteConfig.remoteConfig()
    
    // MARK: - Actions
    @objc func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func  signUpEvent() {
        // 모든 입력이 있는지 확인
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = checkPasswordTextField.text else { return }
        
        if email == "" || password == "" || confirmPassword == "" || password != confirmPassword {
            self.displayLoginOrSignUpFormatAlert()
        }
        
        if isValidEmail(email: email) && isValidPassword(password: password) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let user = authResult?.user, error == nil else {
                    print("cannot create user")
                    
                    let alert = UIAlertController(title: "실패",
                                                  message: "회원가입을 할 수 없습니다.",
                                                  preferredStyle: .alert)
                    
                    if let err = error as NSError? {
                        if AuthErrorCode(rawValue: err.code) == .emailAlreadyInUse {
                            alert.message = "이미 존재하는 이메일입니다."
                        }
                    }
                    
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                    
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.checkPasswordTextField.text = nil
                    
                    return
                }
                
                UserDefaultsManager.userId = email
                UserDefaultsManager.token = user.uid
                UserDefaultsManager.social = ""
                
                // 서버로 email(email), firebase uid(token) 전송
                self.postSignUpInformation()
                
                let alert = UIAlertController(title: "회원가입 성공",
                                              message: "환영합니다!",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.cancelEvent()
                })
                
                self.present(alert, animated: true)
        }
    }
}
    
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
    
    @objc func checkPasswordDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if passwordTextField.text == nil || text != passwordTextField.text {
                    floatingLabelTextField.errorMessage  = "입력하신 비밀번호가 다릅니다."
                } else {
                    floatingLabelTextField.errorMessage = ""
                    floatingLabelTextField.title = "비밀번호가 일치합니다."
                    floatingLabelTextField.titleColor = .blue
                }
            }
        }
    }
    
    @objc func passwordDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabeltextField = textfield as? SkyFloatingLabelTextField {
                if !isValidPassword(password: text) {
                    floatingLabeltextField.errorMessage = "대/소문자, 숫자 8자리 이상 입력해주세요."
                } else {
                    floatingLabeltextField.errorMessage = ""
                }
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        checkPasswordTextField.addTarget(self, action: #selector(checkPasswordDidChange), for: .editingChanged)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: - Custom Methods
    func initProperties() {
        self.color = remoteConfig["splash_background"].stringValue
        
        signUpButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        signUpButton.backgroundColor = UIColor(hex: color)
        cancelButton.backgroundColor = UIColor(hex: color)
        
        setTextFieldLayout(textField: emailTextField, title: "Email")
        setTextFieldLayout(textField: passwordTextField, title: "Password")
        setTextFieldLayout(textField: checkPasswordTextField, title: "Confirm Password")
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
    
    /// 이메일 형식을 확인하는 함수
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    /// 비밀번호 형식을 확인하는 함수
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "[a-zA-Z0-9]{8,16}$" // 소문자, 대문자, 숫자 8자리 이상 16자리 이하
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: password)
    }
    
    func displayLoginOrSignUpFormatAlert() {
        let alert = UIAlertController(title: "실패", message: "이메일/비밀번호를 확인해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func postSignUpInformation() {
        let email = UserDefaultsManager.userId
        let token = UserDefaultsManager.token
        let param = ["email": email, "token": token]
        let paramData = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: "http://3.36.149.10:55670/api/user/signup") else {
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
