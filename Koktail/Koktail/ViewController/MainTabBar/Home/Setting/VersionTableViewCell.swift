//
//  VersionTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit

class VersionTableViewCell: UITableViewCell {

    @IBOutlet weak var currentVersion: UILabel!
    @IBOutlet weak var versionState: UILabel!
    
    public static let identifier = "VersionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCell()
    }
    
    private func setCell() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
        currentVersion.text = "현재버전" + " \(appVersion)"
    }
}
