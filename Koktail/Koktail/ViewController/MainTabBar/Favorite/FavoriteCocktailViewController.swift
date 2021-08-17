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
    public var cocktails: [Cocktail] = []
    
    // manage view
    private var isFirstViewLoaded: Bool = true
    private let indicator: UIRefreshControl = UIRefreshControl()
    public var navigation: UINavigationController?
    
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

        self.cocktailCollectionView.register(
            UINib(nibName: EmptyFavoriteCocktailCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: EmptyFavoriteCocktailCollectionViewCell.identifier)

        self.cocktailCollectionView.register(
            UINib(nibName: FavoriteCocktailCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier:
                FavoriteCocktailCollectionViewCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 30,
                                               left: 20,
                                               bottom: 50,
                                               right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10

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
                        self.isFirstViewLoaded = false
                    }
                }
            }
        }.resume()
    }
}

// MARK: - Collection View
extension FavoriteCocktailViewController: UICollectionViewDelegate,
                                          UICollectionViewDelegateFlowLayout,
                                          UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if self.isFirstViewLoaded { return 0 }
        if cocktails.isEmpty { return 1 }
        
        return cocktails.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if self.cocktails.isEmpty {
            return CGSize(width: self.view.bounds.width * 0.8,
                          height: 350)
        } else {
            return CGSize(width: self.view.bounds.width / 2.5, height: self.view.bounds.height / 3)
        }
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if cocktails.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmptyFavoriteCocktailCollectionViewCell.identifier,
                    for: indexPath)
                    as? EmptyFavoriteCocktailCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.makeCell()
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCocktailCollectionViewCell.identifier,
                    for: indexPath)
                    as? FavoriteCocktailCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.makeCell(cocktail: cocktails[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cocktailDetailViewController = CocktailDetailViewController()
        let cocktailInformation: CocktailInfo = CocktailInfo(cocktailId: self.cocktails[indexPath.row].id,
                                                             image: self.cocktails[indexPath.row].image,
                                                             name: self.cocktails[indexPath.row].name,
                                                             alcohol: self.cocktails[indexPath.row].alcohol)
        
        cocktailDetailViewController.cocktailInfo = cocktailInformation
        self.navigation?.pushViewController(cocktailDetailViewController, animated: true)
    }
}
