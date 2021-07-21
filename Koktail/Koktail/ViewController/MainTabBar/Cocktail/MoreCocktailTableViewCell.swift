//
//  MoreCocktailTableViewCell.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/15.
//

import UIKit

class MoreCocktailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailInfoLabel: UILabel!
    
    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
