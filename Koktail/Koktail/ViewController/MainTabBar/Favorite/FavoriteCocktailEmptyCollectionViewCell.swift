//
//  FavoriteCocktailEmptyCollectionViewCell.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/08.
//

import UIKit

class FavoriteCocktailEmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properites
    @IBOutlet weak var emptyCocktailImageView: UIImageView!
    
    public static let identifier = "FavoriteCocktailEmptyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emptyCocktailImageView.image = UIImage(named: "empty_folder")
    }
}
