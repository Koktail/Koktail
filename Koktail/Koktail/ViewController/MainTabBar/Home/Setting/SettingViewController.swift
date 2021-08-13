//
//  SettingViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import Carte
import Firebase
import KakaoSDKAuth
import KakaoSDKUser

class SettingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var settingTableView: UITableView!
    private let reauthenticateViewController = ReAuthenticateUserViewController()
    
    // MARK: - OVerride Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigation()
    }
    
    // MARK: - Set Navigation
    private func setNavigation() {
        guard let navigation = self.navigationController else { return }
        navigation.navigationBar.tintColor = .black
        navigation.interactivePopGestureRecognizer?.delegate = nil
        navigationItem.title = "환경설정"
    }
    
    // MARK: - Set TableView
    private func setTableView() {
        settingTableView.register(
            UINib(nibName: LogOutTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: LogOutTableViewCell.identifier
        )
        
        settingTableView.register(
            UINib(nibName: VersionTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: VersionTableViewCell.identifier
        )
        
        settingTableView.register(
            UINib(nibName: OpenSourceTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: OpenSourceTableViewCell.identifier
        )
        
        settingTableView.register(
            UINib(nibName: DeleteAccountTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: DeleteAccountTableViewCell.identifier)
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.isScrollEnabled = false
    }
    
    // MARK: - Networking Methods
    private func deleteAccountEvent() {
        if UserDefaultsManager.social == "" {
            self.present(self.reauthenticateViewController, animated: true)
        } else if UserDefaultsManager.social == "kakao" {
            let alert = UIAlertController(title: "안내",
                                          message: "회원 탈퇴를 하시겠습니까?",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "네",
                                         style: .default) { _ in
                self.deleteKakaoAccountAtFirebase()
            }
            let cancelAction = UIAlertAction(title: "아니요",
                                             style: .cancel)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
    /// 카카오 계정을 파이어배이스에서 삭제
    private func deleteKakaoAccountAtFirebase() {
        // 파이어베이스에서 삭제한 뒤에 카카오계정에서 unlink
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                print("cannot access kakao user")
                print(error.localizedDescription)
                return
            }
            
            guard let password = kakaoUser?.id else {
                return
            }
            guard let currentUser = Auth.auth().currentUser else {
                print("Cannot get current user")
                return
            }
            
            currentUser.delete { error in
                if let error = error {
                    print("Cannot Delete user")
                    print(error.localizedDescription)
                    
                    let credential: AuthCredential = EmailAuthProvider.credential(
                        withEmail: UserDefaultsManager.userId,
                        password: String(describing: password))
                    
                    currentUser.reauthenticate(with: credential) { authResult, error in
                        if let error = error {
                            print("Cannot reauthenticate user")
                            print(error.localizedDescription)
                            
                            self.showErrorAlert()
                            return
                        }
                        
                        authResult?.user.delete(completion: { error in
                            if let error = error {
                                print("Really cannot delete...")
                                print(error.localizedDescription)
                                
                                self.showErrorAlert()
                                return
                            }
                            
                            print("Finally delete current user!")
                            self.initUserAndBackLoginPage()
                        })
                    }
                } else {
                    print("Success delete kakao Account at Firebase")
                    self.initUserAndBackLoginPage()
                }
            }
        }
    }
    
    private func initUserAndBackLoginPage() {
        UserApi.shared.unlink { error in
            if let error = error {
                print("Cannot unlink kakao")
                print(error.localizedDescription)
                return
            }
        }
        
        deleteAccountAPI()
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
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "안내",
                                      message: "회원 탈퇴를 할 수 없습니다. 다시 시도해주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인",
                                      style: .default,
                                      handler: nil))
        
        self.present(alert, animated: true)
    }
}

// MARK: - TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1, 2:
            return 80
        case 3:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: LogOutTableViewCell.identifier,
                    for: indexPath
            ) as? LogOutTableViewCell else {
                return UITableViewCell()
            }
            cell.settingViewController = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: VersionTableViewCell.identifier,
                    for: indexPath
            ) as? VersionTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OpenSourceTableViewCell.identifier,
                for: indexPath
            ) as? OpenSourceTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DeleteAccountTableViewCell.identifier,
                    for: indexPath
            ) as? DeleteAccountTableViewCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 2:
            let carteViewController = CarteViewController()
            guard let navigation = self.navigationController else { return }
            navigation.pushViewController(carteViewController, animated: true)
        case 3:
            deleteAccountEvent()
        default:
            break
        }
    }
}
