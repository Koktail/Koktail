//
//  HomeViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRightNavigationButton()
    }
    
    // MARK: - Set Navigation
    private func setRightNavigationButton() {
        let settingButtonItem = UIBarButtonItem(
            image: UIImage(named: "setting_button"),
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(barButtonTap(sender:))
        )
        settingButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    // MARK: - objc Action
    @objc func barButtonTap(sender: UIBarButtonItem) {
        let settingTableViewController = SettingViewController()
        settingTableViewController.hidesBottomBarWhenPushed = true
        
        guard let navigation = self.navigationController else { return }
        navigation.pushViewController(settingTableViewController, animated: true)
    }
}
