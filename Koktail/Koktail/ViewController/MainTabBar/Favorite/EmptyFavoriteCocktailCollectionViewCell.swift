//
//  EmptyFavoriteCocktailCollectionViewCell.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/13.
//

import UIKit
import SnapKit

class EmptyFavoriteCocktailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var emptyImageView: UIImageView!
    public static let identifier = "EmptyFavoriteCocktailCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func makeCell() {
        self.emptyImageView.image = UIImage(named: "empty_folder")
        self.emptyImageView.contentMode = .scaleAspectFit
    }
}
