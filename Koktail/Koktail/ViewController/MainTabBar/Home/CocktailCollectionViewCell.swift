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
    }

}
