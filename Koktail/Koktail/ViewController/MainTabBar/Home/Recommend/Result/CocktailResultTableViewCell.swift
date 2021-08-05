//
//  CocktailResultTableViewCell.swift
//  xib_result
//
//  Created by 형주 on 2021/07/16.
//

import UIKit

class CocktailResultTableViewCell: UITableViewCell {
    @IBOutlet weak var CocktailImage: UIImageView!
    @IBOutlet weak var Imageview: UIView!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var CocktailName: UILabel!
    @IBOutlet weak var CocktailInfo: UILabel!
    @IBOutlet weak var CocktailAlc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
