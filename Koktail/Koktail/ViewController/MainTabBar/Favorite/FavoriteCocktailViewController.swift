//
//  FavoriteCocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit

class FavoriteCocktailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var cocktailCollectionView: UICollectionView!
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        UtilFunction.setGradient(baseView: cocktailCollectionView, "#fad0c4", "#ffd1ff")
    }
    
    // MARK: - Set Collection View
    private func setCollectionView() {
        cocktailCollectionView.delegate = self
        cocktailCollectionView.dataSource = self
    }
}

// MARK: - Collection View
extension FavoriteCocktailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
