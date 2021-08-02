//
//  PlaceInfoTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit

class PlaceInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeSiteURL: UITextView!
    @IBOutlet weak var placePhoneNumber: UILabel!
    
    public static let identifier = "PlaceInfoTableViewCell"
    private var url = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wordsTapped))
        placeSiteURL.addGestureRecognizer(tapRecognizer)
    }
    
    public func makeCell(place: Detail) {
        placeAddress.text = place.formatted_address
        placeSiteURL.text = place.website
        placePhoneNumber.text = place.formatted_phone_number
        
        url = place.website
    }
    
    @objc func wordsTapped() {
        guard let url = URL(string: self.url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
