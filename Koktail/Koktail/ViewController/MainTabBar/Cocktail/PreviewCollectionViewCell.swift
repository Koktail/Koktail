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
        if let imgURL = cocktailInfo.image{
            setImgView(imgURL)
        }else{
            self.imageView.image = UIImage(named: "cocktail")
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
    
    private func setImgView(_ imgURL : String){
        guard let url = URL(string: imgURL) else {
            return
        }
        
        do{
            let data = try Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }catch{
            return
        }
    }
}
