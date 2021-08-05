//
//  CocktailCollectionViewCell.swift
//  Koktail
//
//  Created by 형주 on 2021/07/02.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cocktailImg: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cocktailName: UILabel!
    @IBOutlet weak var cocktailDegree: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cocktailImg.layer.cornerRadius = 20
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 0.1
        self.view.layer.cornerRadius = 20
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.view.layer.shadowRadius = 2
    }

}
