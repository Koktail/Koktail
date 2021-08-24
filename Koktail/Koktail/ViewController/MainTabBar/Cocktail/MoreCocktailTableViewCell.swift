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
    
    // MARK: - Custom Methods
    public func setTableViewCell(_ cocktailInfo: CocktailInfo) {
        if let imgURL = cocktailInfo.image {
            setImgView(imgURL)
        } else {
            self.imgView.image = UIImage(named: "cocktail")
        }
        
        self.cocktailNameLabel.text = cocktailInfo.name
        
        switch cocktailInfo.alcohol {
        case "HIGH":
            self.cocktailInfoLabel.text = "도수 : 🤪(상)"
        case "MID":
            self.cocktailInfoLabel.text = "도수 : 🤤(중)"
        case "LOW":
            self.cocktailInfoLabel.text = "도수 : 🙂(하)"
        default:
            break
        }
    }
    
    private func setImgView(_ imgURL: String) {
        guard let url = URL(string: imgURL) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: data)
            }
        } catch {
            return
        }
    }
    
}
