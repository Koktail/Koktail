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
    
    public func makeCell(place: Detail) {
        placeTitle.text = place.name
        placeRating.text = "\(place.rating)"
        reviews.text = "\(place.reviews.count)개"
        placeType.text = place.types.first
        setRatingView(rating: place.rating)
    }
    
    private func setRatingView(rating: Double) {
        ratingView.type = .halfRatings
        ratingView.maxRating = 5
        ratingView.minRating = 0
        
        ratingView.backgroundColor = UIColor.clear
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        
        ratingView.emptyImage = UIImage(named: "ic_star_empty")!
        ratingView.fullImage = UIImage(named: "ic_star_full")!
        
        ratingView.rating = rating
    }
}
