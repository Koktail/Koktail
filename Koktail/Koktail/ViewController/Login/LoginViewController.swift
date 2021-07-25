//
//  LoginViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import SnapKit
import Firebase
import KakaoSDKUser

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let tabBarViewController = MainTabBarController()
    private let loginPageViewController = LoginPageViewController()
    
    private var logoImageView = UIImageView()
    
    // firebase
    var remoteConfig: RemoteConfig!
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 파이어베이스 로그아웃
        // try? Auth.auth().signOut()
        
        // 카카오톡 로그인 토큰 삭제
        UserApi.shared.unlink { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("unlink success")
            }
        }
        
        initRemoteConfig()
        displayLogoImage()
    }
    
    // MARK: - Custom Method
    func displayLogoImage() {
        // launch View에 logo 이미지 띄우기
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(200)
            make.height.equalTo(200)
        }
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "cocktail")
    }
    
    func initRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // 서버 연결이 안되는 경우에 사용할 디폴트
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) in
            if status == .success {
                print("Success")
                self.remoteConfig.activate()
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            self.checkFirebaseState()
        }
    }

    func checkFirebaseState() {
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if caps {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            decideNextView()
        }
        
        self.view.backgroundColor = UIColor(hex: color!)
    }
    
    func decideNextView() {
        if isUserLoggedIn() {
            self.view.window?.switchRootViewController(self.tabBarViewController)
        } else {
            print("no user")
            self.view.window?.switchRootViewController(self.loginPageViewController)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
}
