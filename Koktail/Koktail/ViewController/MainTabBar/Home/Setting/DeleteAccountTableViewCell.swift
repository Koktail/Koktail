//
//  DeleteAccountTableViewCell.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/09.
//

import UIKit
import SnapKit

class DeleteAccountTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var deleteAccountLabel: UILabel!
    
    public static let identifier = "DeleteAccountTableViewCell"

    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabel()
    }
    
    // MARK: - Custom Button
    private func setLabel() {
        self.deleteAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.deleteAccountLabel.textColor = .systemRed
    }
}
