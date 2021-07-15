//
//  CategoryTableViewCell.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/13.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let previews: [String:[String]] = [
        "보드카" : ["블러디 메리", "치치", "블랙 러시안", "스크류 드라이버"],
        "리큐르" : ["그라스 호퍼", "준벅", "미도리 사워", "깔루아 밀크"],
        "럼" : ["바카디", "마이티이", "블루 하와이", "피나 콜라다"],
        "데킬라" : ["마가리타", "데킬라 선라이즈"],
        "위스키" : ["갓 파더", "맨하탄"],
        "진" : ["진토닉", "롱 아일랜드 아이스티", "싱가폴 슬링", "마티니"],

        "무알콜" : ["모히또"],
        "😋" : ["마이티이", "깔루아 밀크", "피나 콜라다"],
        "🤤" : ["블러디 메리", "그라스 호퍼", "치치", "준벅", "미도리 사워", "진토닉", "싱가폴 슬링", "블루 하와이", "마가리타", "데킬라 선라이즈"],
        "🤪" : ["바카디", "롱 아일랜드 아이스티", "블랙 러시안", "스크류 드라이버", "갓 파더", "맨하탄"],

        "sweet" : ["블러디 메리", "그라스 호퍼", "치치", "준벅", "미도리 사워", "바카디", "마이티이", "롱 아일랜드 아이스티", "블랙 러시안", "싱가폴 슬링", "스크류 드라이버", "블루 하와이", "데킬라 선라이즈", "깔루아 밀크", "피나 콜라다"],
        "sour" : ["준벅", "미도리 사워", "바카디", "진토닉", "롱 아일랜드 아이스티", "싱가폴 슬링", "스크류 드라이버", "마가리타"],
        "bitter" : ["진토닉", "갓 파더"],
        "dry" : ["맨하탄"]
        ]
    
    var navigation: UINavigationController?
    
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var seeMoreCocktailButton: UIButton!
    @IBOutlet weak var previewCollectionView: UICollectionView!

    // MARK: - Actions
    @IBAction func seeMoreCocktailAction(_ sender: UIButton) {
        
//        let moreCocktailVC = MoreCocktailViewController()
//
//        moreCocktailVC.navigation = self.navigation
//        moreCocktailVC.categoryName = categoryLabel.text!
//
//        navigation?.pushViewController(moreCocktailVC, animated: true)
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
        
        backgroundView?.layer.borderWidth = 0.2
        backgroundView?.layer.cornerRadius=8
        backgroundView?.clipsToBounds=true
        
        previewCollectionView.collectionViewLayout = layout
    }
    
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return previews[categoryLabel.text!]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCollectionViewCell", for: indexPath) as! PreviewCollectionViewCell
        
        cell.imageView.image = UIImage(named: "cosmopolitan.jpeg")
        cell.cocktailNameLabel.text = previews[categoryLabel.text!]![indexPath.row]
        cell.cocktailInfoLabel.text = "20% | 진"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = DetailViewController()
//
//        detailVC.cocktailName = previews[categoryLabel.text!]![indexPath.row]
//
//        navigation?.pushViewController(detailVC, animated: true)
    }
}
