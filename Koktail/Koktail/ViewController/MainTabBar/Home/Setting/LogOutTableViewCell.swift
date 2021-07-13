//
//  LogOutTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import RxCocoa
import RxSwift

class LogOutTableViewCell: UITableViewCell {

    @IBOutlet weak var socialInfo: UIView!
    @IBOutlet weak var userId: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    public static let identifier = "LogOutTableViewCell"
    public var settingViewController: SettingViewController?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoutButton.rx.tap.bind {
            self.logoutAlert()
        }.disposed(by: disposeBag)
    }
    
    private func logoutAlert() {
        let alert = UIAlertController(title: "안내", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            print("logout")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        settingViewController?.present(alert, animated: true)
    }
}
