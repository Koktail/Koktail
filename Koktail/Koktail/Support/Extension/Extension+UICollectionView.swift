//
//  Extension+UICollectionView.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/13.
//

import UIKit
import SnapKit

extension UICollectionView {
    func setEmptyView(title: String, message: String, image: UIImage) {
        let emptyView = UIView(frame:
                                CGRect(x: self.center.x,
                                       y: self.center.y,
                                       width: self.bounds.width,
                                       height: self.bounds.height))
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.textColor = .black
            label.font.withSize(17)
            
            return label
        }()
        
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .lightGray
            label.font.withSize(17)
            label.numberOfLines = 0
            label.textAlignment = .center
            
            return label
        }()
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
            make.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.backgroundView = emptyView
    }
    
    func deleteEmptyView() {
        self.backgroundView = nil
    }
}
