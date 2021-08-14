//
//  FavoriteViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionPage: UICollectionView!
    
    private var items = [UIViewController]()
    private let collectionPageIdentifier = "CollectionPageID"
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setColletionView()
        setSegamentButtton()
        
        let cocktailView = FavoriteCocktailViewController()
        let storeView = FavoriteStoreViewController()
        
        items.append(cocktailView)
        items.append(storeView)
    }
    
    // MARK: - Set Navigation
    private func setNavigationBar() {
        self.navigationItem.title = "찜목록"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(
            red: 245/255,
            green: 98/255,
            blue: 90/255,
            alpha: 1.0
        )
    }
    
    // MARK: - Set Colletion View
    private func setColletionView() {
        let flowPageLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
        }
        
        collectionPage.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: collectionPageIdentifier
        )
        collectionPage.setCollectionViewLayout(flowPageLayout, animated: true)
        collectionPage.showsHorizontalScrollIndicator = false
        collectionPage.isScrollEnabled = false
        collectionPage.delegate = self
        collectionPage.dataSource = self
        collectionPage.reloadData()
    }
    
    // MARK: - Set Segment Button
    private func setSegamentButtton() {
        segmentController.addTarget(
            self,
            action: #selector(segmentTap(segcon:)),
            for: .valueChanged
        )
    }
    
    @objc func segmentTap(segcon: UISegmentedControl) {
        let path = IndexPath(item: segcon.selectedSegmentIndex, section: 0)
        
        collectionPage.scrollToItem(at: path, at: .centeredHorizontally, animated: false)
        collectionPage.reloadData()
    }
}

// MARK: - Collection View
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let pageHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        return CGSize(width: view.frame.width, height: pageHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionPageIdentifier,
            for: indexPath
        )
        
        let viewController = items[indexPath.row]
        cell.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints {
            $0.top.equalTo(cell.snp.top)
            $0.leading.equalTo(cell.snp.leading).offset(self.view.safeAreaInsets.left)
            $0.trailing.equalTo(cell.snp.trailing).offset(-self.view.safeAreaInsets.right)
            $0.bottom.equalTo(cell.snp.bottom)
        }
        return cell
    }
}
