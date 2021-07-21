//
//  PreviewCollectionViewCell.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/15.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailInfoLabel: UILabel!
    
    // MARK: - Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
