//
//  PlaceReviewsTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit
import FloatRatingView

class PlaceReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var relativeTime: UILabel!
    @IBOutlet weak var reviewText: UITextView!
    
    public static let identifier = "PlaceReviewsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRatingView(rating: 4.0)
    }
    
    private func setRatingView(rating: Double) {
        ratingView.type = .halfRatings
        ratingView.maxRating = 5
        ratingView.minRating = 0
        
        ratingView.backgroundColor = UIColor.clear
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        
        ratingView.emptyImage = UIImage(named: "ic_star_empty")!
        ratingView.fullImage = UIImage(named: "ic_star_full")!
        
        ratingView.rating = 4
    }
}
