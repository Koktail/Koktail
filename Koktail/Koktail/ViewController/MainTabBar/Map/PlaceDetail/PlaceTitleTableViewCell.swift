//
//  PlaceTitleTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit
import FloatRatingView
import RealmSwift
import SwiftEventBus

class PlaceTitleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeRating: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var placeType: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    // identifier
    public static let identifier = "PlaceTitleTableViewCell"
    
    // realm
    private var realm: Realm?
    private var storeData: StoreData?
    
    // data
    public var placeDetail: PlaceDetail? {
        didSet {
            loadRealm()
        }
    }
    
    // MARK: - Action
    @IBAction func favorite(_ sender: Any) {
        saveData()
    }
    
    // MARK: - Override Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Set Cell
    public func makeCell(place: Detail) {
        placeTitle.text = place.name
        placeRating.text = "\(place.rating)"
        reviews.text = "\(place.reviews.count)개"
        placeType.text = place.types.first
        setRatingView(rating: place.rating)
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
    
    // MARK: - Set Realm
    private func loadRealm() {
        guard let placeDetail = self.placeDetail else { return }
        
        realm = try? Realm()
        print("realm file: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        if let store = realm!.objects(StoreData.self).filter(
            NSPredicate(
                format: "store_title = %@",
                placeDetail.result.name
            )
        ).first {
            favorite.setImage(UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
            favorite.tintColor = UIColor(
                red: 245/255,
                green: 98/255,
                blue: 90/255,
                alpha: 1.0
            )
            self.storeData = store
        } else {
            favorite.setImage(UIImage(named: "favorite_border"), for: .normal)
        }
    }
    
    private func saveData() {
        guard let placeDetail = self.placeDetail else { return }
        
        if let store = self.storeData {
            try? realm?.write {
                realm?.delete(store)
            }
            
            self.storeData = nil
            
            favorite.setImage(UIImage(named: "favorite_border"), for: .normal)
        } else {
            let store = StoreData().then {
                $0.store_title = placeDetail.result.name
                $0.store_website = placeDetail.result.website
                $0.store_phone = placeDetail.result.formatted_phone_number
                $0.store_address = placeDetail.result.formatted_address
                $0.store_rating = "\(placeDetail.result.rating)"
            }
            
            try? realm?.write {
                realm?.add(store)
            }
            
            self.storeData = store
            
            favorite.setImage(UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
            favorite.tintColor = UIColor(
                red: 245/255,
                green: 98/255,
                blue: 90/255,
                alpha: 1.0
            )
        }
        SwiftEventBus.post("changeStoreList")
    }
}
