//
//  CategoryTableViewCell.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/13.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var navigation: UINavigationController?
    var previews: [CocktailInfo] = []
    
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var seeMoreCocktailButton: UIButton!
    @IBOutlet weak var previewCollectionView: UICollectionView!

    // MARK: - Actions
    @IBAction func seeMoreCocktailAction(_ sender: UIButton) {
        
        let moreCocktailVC = MoreCocktailViewController()

        moreCocktailVC.navigation = self.navigation!
        moreCocktailVC.categoryName = categoryLabel.text!
        moreCocktailVC.cocktails = previews

        navigation?.pushViewController(moreCocktailVC, animated: true)
    }
    
    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        
        let nibName = UINib(nibName: "PreviewCollectionViewCell", bundle: nil)
        previewCollectionView.register(nibName, forCellWithReuseIdentifier: "previewCollectionViewCell")
        
        collectionviewLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    // MARK: - Custom Methods
    func collectionviewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .horizontal
//
//        backgroundView?.layer.borderWidth = 0.2
//        backgroundView?.layer.cornerRadius=8
//        backgroundView?.clipsToBounds=true
//
        previewCollectionView.collectionViewLayout = layout
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCollectionViewCell", for: indexPath) as! PreviewCollectionViewCell
        
        cell.imageView.image = UIImage(named: "cosmopolitan.jpeg")
        cell.cocktailNameLabel.text = previews[indexPath.row].name
        
        switch previews[indexPath.row].alcohol {
        case "HIGH":
            cell.cocktailInfoLabel.text = "도수 : 🤪(상)"
        case "MID":
            cell.cocktailInfoLabel.text = "도수 : 🤤(중)"
        case "LOW":
            cell.cocktailInfoLabel.text = "도수 : 🙂(하)"
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = CocktailDetailViewController()
        
        detailVC.cocktailInfo = previews[indexPath.row]

        navigation?.pushViewController(detailVC, animated: true)
    }
}
