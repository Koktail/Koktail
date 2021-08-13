//
//  FavoriteCocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import SnapKit

class FavoriteCocktailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var cocktailCollectionView: UICollectionView!
    var cocktails: [Cocktail] = []
    
    // manage view
    private let indicator: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Actions
    @objc private func loadCocktails() {
        print("refreshing... ")
        
        getFavoriteCocktail()
    }
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFavoriteCocktail()
        setCollectionView()
    }
    
    // MARK: - Set Collection View
    private func setCollectionView() {
        indicator.addTarget(self,
                            action: #selector(loadCocktails),
                            for: .valueChanged)
        
        cocktailCollectionView.refreshControl = indicator
        cocktailCollectionView.delegate = self
        cocktailCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20,
                                               left: 20,
                                               bottom: 60,
                                               right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let width = UIScreen.main.bounds.width / 2.5
        let height = UIScreen.main.bounds.height / 4
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        self.cocktailCollectionView.register(
            UINib(nibName: FavoriteCocktailCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier:
                FavoriteCocktailCollectionViewCell.identifier)

        self.cocktailCollectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Networking
    func getFavoriteCocktail() {
        guard let url = URL(string: "http://3.36.149.10:55670/api/cocktail/like") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(UserDefaultsManager.token,
                            forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                print("ERROR: cannot connect url")
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("ERROR: cannnot load data")
                return
            }
            
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(
                FavoriteCocktailAPIResponse.self,
                from: data) {
                print(json.message)
                
                if json.code == 0 {
                    self.cocktails = json.favoriteCocktailList
                    
                    DispatchQueue.main.async {
                        self.cocktailCollectionView.reloadData()
                        self.indicator.endRefreshing()
                    }
                }
            }
        }.resume()
    }
}

// MARK: - Collection View
extension FavoriteCocktailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if cocktails.isEmpty {
            collectionView.setEmptyView(
                title: "찜한 칵테일이 없습니다.",
                message: "마음에 드는 칵테일을 찜해보세요.",
                image: UIImage(named: "empty_folder") ?? UIImage()
            )
        } else {
            collectionView.deleteEmptyView()
        }
        
        return cocktails.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FavoriteCocktailCollectionViewCell.identifier,
                for: indexPath)
                as? FavoriteCocktailCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.makeCell(cocktail: cocktails[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktailDetailViewController = CocktailDetailViewController()
        let cocktailInformation: CocktailInfo = CocktailInfo(cocktailId: self.cocktails[indexPath.row].id,
                                                             image: self.cocktails[indexPath.row].image,
                                                             name: self.cocktails[indexPath.row].name,
                                                             alcohol: self.cocktails[indexPath.row].alcohol)
        
        cocktailDetailViewController.cocktailInfo = cocktailInformation
        self.present(cocktailDetailViewController, animated: true)
        
        // self.navigationController?.pushViewController(cocktailDetailViewController, animated: true)
    }
}
