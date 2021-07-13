//
//  LoginViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let tabBarViewController = MainTabBarController()
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let window = self.view.window else { return }
            window.switchRootViewController(self.tabBarViewController)
        }
    }
}
