//
//  SignUpViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/12.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
                    
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                    self.checkPasswordTextField.text = nil
                    
                    return
                }
                print(user.uid)
                
                let alert = UIAlertController(title: "회원가입 성공",
                                              message: "환영합니다!",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.cancelEvent()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                // 데이터베이스 설게 후 Database로 정보 저장
                // 데이터베이스 설계 후 이미 존재하는 아이디인지 확인
        }
    }
}
    
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if text.count < 3 || !text.contains("@") {
                    floatingLabelTextField.errorMessage = "Invalid Email"
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
        
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        checkPasswordTextField.addTarget(self, action: #selector(checkPasswordDidChange), for: .editingChanged)
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
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
