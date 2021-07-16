//
//  ForgotAndUpdatePasswordViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/16.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class ForgotAndUpdatePasswordViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var color: String = "#000000"
    
    // MARK: - Actions
    @objc func sendEmailEvent() {
        guard let email = emailTextField.text else {
            return
        }
        
        if email != "" {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error == nil {
                    // success
                    let alert = UIAlertController(title: "전송 완료",
                                                  message: "메일을 전송했습니다. 비밀번호 변경해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.cancelEvent()
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print(error!.localizedDescription)
                    
                    let alert = UIAlertController(title: "전송 실패", message: "이메일을 확인해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textfieldDidChange(_ textfield: UITextField) {
        if let text = emailTextField.text {
            if let floatingTextField = textfield as? SkyFloatingLabelTextField {
                if !isValidEmail(email: text) {
                    floatingTextField.errorMessage = "잘못된 이메일 형식입니다."
                } else {
                    floatingTextField.errorMessage = ""
                }
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.placeholder = "Email"
        setTextFieldLayout(textField: emailTextField, title: "Email")
        
        sendEmailButton.backgroundColor = UIColor(hex: color)
        sendEmailButton.layer.cornerRadius = 5
        
        cancelButton.backgroundColor = UIColor(hex: color)
        cancelButton.layer.cornerRadius = 5
        
        sendEmailButton.addTarget(self, action: #selector(sendEmailEvent), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textfieldDidChange), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    // MARK: - Custom Methods
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
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
    
}
