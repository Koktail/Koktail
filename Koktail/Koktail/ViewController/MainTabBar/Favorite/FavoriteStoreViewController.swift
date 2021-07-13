//
//  FavoriteStoreViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit

class FavoriteStoreViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var storeCollectionView: UICollectionView!
    
    // MARK: - Overrride Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        UtilFunction.setGradient(baseView: storeCollectionView, "#ff9a9e", "#fecfef")
    }
    
    // MARK: - Set Collection View
    private func setCollectionView() {
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
    }
}

// MARK: - Collection View
extension FavoriteStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
