//
//  LoginPageViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/09.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginPageViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
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
                UserDefaultsManager.userId = email
                self.view.window?.switchRootViewController(self.tabBarViewController)
            }
        }
    }
    
    @objc func kakaoLoginEvent() {
        print("KAKAO login button clicked")
        
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    print("________ login error ________")
                    
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        self.checkKaKaoTalkAppIsAvailable()
                    } else {
                        print(error.localizedDescription)
                    }
                } else {
                    print("accessTokenInfo ok")
                    self.view.window?.switchRootViewController(self.tabBarViewController)
                }
            }
        } else {
            self.checkKaKaoTalkAppIsAvailable()
        }
    }
    
    /// 카카오톡 설치 여부를 확인 후 계정에 로그인
    func checkKaKaoTalkAppIsAvailable() {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 간편 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("APP KAKAO LOGIN")
                    
                    _ = oauthToken
                    
                    self.kakaoLoginToFireBaseLogin()
                    
                    self.view.window?.switchRootViewController(self.tabBarViewController)
                }
            }
        } else { // 카카오톡 웹 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("WEB KAKAO LOGIN")
                    
                    _ = oauthToken
                    
                    self.kakaoLoginToFireBaseLogin()
                    
                    self.view.window?.switchRootViewController(self.tabBarViewController)
                }
            }
        }
    }
    
    /// 카카오톡으로 로그인한 정보를 파이어베이스에 등록
    func kakaoLoginToFireBaseLogin() {
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("< KAKAO: user loading failed >")
                print(error.localizedDescription)
            } else {
                guard let nickName = kakaoUser?.kakaoAccount?.profile?.nickname else {
                    return
                }
                guard let password = kakaoUser?.id else {
                    return
                }
                
                Auth.auth().createUser(withEmail: nickName,
                                       password: String(describing: password)) { _, error in
                    if let error = error {
                        print("< FIREBASE: signUp failed >")
                        print(error.localizedDescription)
                        
                        Auth.auth().signIn(withEmail: nickName,
                                           password: String(describing: password),
                                           completion: nil)
                    } else {
                        print("< FIREBASE: signup success >")
                    }
                }
            }
        }
    }
    
    @objc func appleLoginEvent() {
        print("____ clicked apple login button ____")
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
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(findAndUpdatePasswordEvent), for: .touchUpInside)
        
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginEvent), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginEvent), for: .touchUpInside)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
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
        
        appleLoginButton.setBackgroundImage(#imageLiteral(resourceName: "loginLogo_apple"), for: .normal)
        kakaoLoginButton.setBackgroundImage(#imageLiteral(resourceName: "loginLogo_kakao"), for: .normal)
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
        let alert = UIAlertController(title: "실패",
                                      message: "이메일/비밀번호를 확인해주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
