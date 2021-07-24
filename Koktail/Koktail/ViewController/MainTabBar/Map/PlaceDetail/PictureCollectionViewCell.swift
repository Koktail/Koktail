//
//  PictureCollectionViewCell.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var picture: UIImageView!
    
    public static let identifier = "PictureCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
