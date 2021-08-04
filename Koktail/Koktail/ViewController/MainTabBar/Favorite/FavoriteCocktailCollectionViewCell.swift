//
//  FavoriteCocktailCollectionViewCell.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/02.
//

import UIKit

class FavoriteCocktailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var alchol: UILabel!
    
    public static let identifier = "FavoriteCocktailCollectionViewCell"
    
    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func makeCell(cocktail: Cocktail) {
        cocktailNameLabel.text = cocktail.name
        alchol.text = cocktail.fullAlcohol
    }
}
