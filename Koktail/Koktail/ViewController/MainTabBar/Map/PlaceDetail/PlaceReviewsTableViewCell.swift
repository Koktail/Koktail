//
//  PlaceReviewsTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit
import FloatRatingView
import Kingfisher

class PlaceReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var relativeTime: UILabel!
    @IBOutlet weak var reviewText: UITextView!
    
    public static let identifier = "PlaceReviewsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func makeCell(author: Review) {
        guard let url = URL(string: author.profile_photo_url) else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: author.profile_photo_url)
        let processor = DownsamplingImageProcessor(size: authorPhoto.bounds.size)
        authorPhoto.kf.setImage(
            with: resource,
            options: [
                .transition(.fade(0.3)),
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        
        authorName.text = author.author_name
        relativeTime.text = author.relative_time_description
        reviewText.text = author.text
        setRatingView(rating: author.rating)
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
