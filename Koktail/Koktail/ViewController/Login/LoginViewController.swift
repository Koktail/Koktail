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
    
    // firebase
    var remoteConfig: RemoteConfig!
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#EE6E62")
        initRemoteConfig()
    }
    
    // MARK: - Networking Firebase
    private func initRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // 서버 연결이 안되는 경우에 사용할 디폴트
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) in
            if status == .success {
                print("Success remoteConfig fetched")
                self.remoteConfig.activate()
            } else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            self.checkFirebaseState()
        }
    }

    private func checkFirebaseState() {
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if caps {
            let alert = UIAlertController(title: "알림",
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                exit(0)
            })
            
            self.present(alert, animated: true)
        } else {
            decideNextView()
        }
    }
    
    // MARK: - Custom Methods
    private func decideNextView() {
        if isUserLoggedIn() {
            self.view.window?.switchRootViewController(self.tabBarViewController)
        } else {
            self.view.window?.switchRootViewController(self.loginPageViewController)
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil
            && UserDefaultsManager.userId != "" {
            return true
        } else {
            return false
        }
    }
}
