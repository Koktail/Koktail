//
//  SettingViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import Carte

class SettingViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var settingTableView: UITableView!
    
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
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.isScrollEnabled = false
    }
}

// MARK: - TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1, 2:
            return 80
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
        default:
            break
        }
    }
}
