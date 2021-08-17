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
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var alchol: UILabel!
    
    public static let identifier = "FavoriteCocktailCollectionViewCell"
    
    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func makeCell(cocktail: Cocktail) {
        setImageView()
        
        cocktailNameLabel.text = cocktail.name
        alchol.text = cocktail.fullAlcohol
        
        if let imageString = cocktail.image {
            guard let imageURL = URL(string: imageString) else {
                cocktailImageView.image = UIImage(named: "cocktail")
                return
            }
            do {
                guard let data = try? Data(contentsOf: imageURL) else {
                    cocktailImageView.image = UIImage(named: "cocktail")
                    return
                }
                
                cocktailImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func setImageView() {
        self.cocktailImageView.contentMode = .scaleAspectFit
        
        self.cocktailImageView.layer.cornerRadius = 20
        
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 0.1
        self.view.layer.cornerRadius = 20
        
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.view.layer.shadowRadius = 2
    }
}
