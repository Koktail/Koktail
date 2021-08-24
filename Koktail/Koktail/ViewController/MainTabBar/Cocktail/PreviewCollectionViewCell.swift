//
//  PreviewCollectionViewCell.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/15.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailInfoLabel: UILabel!
    
    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.cornerRadius = 20
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 0.1
        self.view.layer.cornerRadius = 20
        self.view.layer.shadowColor = UIColor.gray.cgColor
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.view.layer.shadowRadius = 2
    }
    
    public func setCollectionViewCell(_ cocktailInfo: CocktailInfo){
        
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
        
        if let imgURL = cocktailInfo.image {
            setImgView(imgURL)
        } else {
            self.imageView.image = UIImage(named: "cocktail")
        }
    }
    
    private func setImgView(_ imgURL : String) {
        self.imageView.image = UIImage.init()
        guard let url = URL(string: imgURL) else {
            return
        }
        
        DispatchQueue.global().async {
            let data: Data?
            do{
                data = try? Data(contentsOf: url)
            } catch {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        
    }
}
