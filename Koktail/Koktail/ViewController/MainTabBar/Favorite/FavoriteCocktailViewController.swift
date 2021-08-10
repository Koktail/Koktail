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
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFavoriteCocktail()
        // initCocktail()
        
        setCollectionView(cocktailsEmpty: cocktails.isEmpty)
    }
    
    // MARK: - Set Collection View
    private func setCollectionView(cocktailsEmpty: Bool) {
        cocktailCollectionView.delegate = self
        cocktailCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20,
                                               left: 20,
                                               bottom: 60,
                                               right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        if !cocktailsEmpty {
            let width = UIScreen.main.bounds.width / 2.5
            let height = UIScreen.main.bounds.height / 4
            
            flowLayout.itemSize = CGSize(width: width, height: height)
            
            self.cocktailCollectionView.register(
                UINib(nibName: FavoriteCocktailCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier:
                    FavoriteCocktailCollectionViewCell.identifier)
            
        } else {
            let width = UIScreen.main.bounds.width / 1.5
            let height = UIScreen.main.bounds.height / 2
            
            flowLayout.itemSize = CGSize(width: width, height: height)
            
            self.cocktailCollectionView.register(
                UINib(nibName: FavoriteCocktailEmptyCollectionViewCell.identifier, bundle: nil),
                forCellWithReuseIdentifier:
                    FavoriteCocktailEmptyCollectionViewCell.identifier)
        }
        
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
                }
            }
        }.resume()
    }
    
    // MARK: - Test Method
    func initCocktail() {
        for idx in 1...9 {
            let cocktail = Cocktail.init(id: UInt64(idx),
                                         image: "",
                                         name: "test\(idx) name",
                                         alcohol: "14.5")
            self.cocktails.append(cocktail)
        }
    }
}

// MARK: - Collection View
extension FavoriteCocktailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if cocktails.isEmpty {
            return 1
        } else {
            return cocktails.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if cocktails.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCocktailEmptyCollectionViewCell.identifier,
                    for: indexPath)
                    as? FavoriteCocktailEmptyCollectionViewCell else {
                return UICollectionViewCell()
            }
            
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
}
