//
//  PlaceTitleTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit
import FloatRatingView

class PlaceTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var placeType: UILabel!
    
    public static let identifier = "PlaceTitleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
