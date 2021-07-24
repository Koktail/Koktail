//
//  PlacePicturesTableViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit

class PlacePicturesTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    public static let identifier = "PlacePicturesTableViewCell"
    
    // MARK: - Override Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
    }
    
    // MARK: - Set Collection View
    private func setCollectionView() {
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        
        pictureCollectionView.register(
            UINib(nibName: PictureCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: PictureCollectionViewCell.identifier
        )
    }
}

extension PlacePicturesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
