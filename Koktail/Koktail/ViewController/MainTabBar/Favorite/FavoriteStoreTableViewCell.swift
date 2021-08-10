//
//  FavoriteStoreTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/08/07.
//

import UIKit
import FloatRatingView

class FavoriteStoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var storeRating: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeWebsite: UITextView!
    @IBOutlet weak var storePhone: UILabel!
    
    public static let identifier = "FavoriteStoreTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func makeCell(store: StoreData) {
        storeTitle.text = store.store_title
        storeRating.text = store.store_rating
        setRatingView(rating: Double(store.store_rating)!)
        storeAddress.text = store.store_address
        storeWebsite.text = store.store_website
        storePhone.text = store.store_phone
    }
    
    private func setRatingView(rating: Double) {
        ratingView.editable = false
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
