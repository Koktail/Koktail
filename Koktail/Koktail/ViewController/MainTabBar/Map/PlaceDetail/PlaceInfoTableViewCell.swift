//
//  PlaceInfoTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit

class PlaceInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeSiteURL: UILabel!
    @IBOutlet weak var placePhoneNumber: UILabel!
    
    public static let identifier = "PlaceInfoTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
