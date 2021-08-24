//
//  FavoriteCocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import SnapKit
import RxSwift

class FavoriteCocktailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var cocktailCollectionView: UICollectionView!
    
    // data
    private var cocktails: [Cocktail] = []
    private var favoriteCocktailViewModel = FavoriteCocktailViewModel()
    
    // manage view
    private var isFirstViewLoaded: Bool = true
    private let indicator: UIRefreshControl = UIRefreshControl()
    public var navigation: UINavigationController?
    
    // RxSwift
    private var disposeBag = DisposeBag()
    
    // MARK: - Actions
    @objc private func loadCocktails() {
        // getFavoriteCocktail()
        netFavoriteCocktailData()
    }
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotificationObserver()
        // getFavoriteCocktail()
        setCollectionView()
        
        bindNetworkingState()
        netFavoriteCocktailData()
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
        
        cocktailCollectionView.contentInset = UIEdgeInsets(top: 20,
                                                           left: 0,
                                                           bottom: 0,
                                                           right: 0)
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: 30,
                                               left: 20,
                                               bottom: 50,
                                               right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10

        self.cocktailCollectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Notification
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadCocktails),
                                               name: .updateFavoriteCocktail,
                                               object: nil)
    }
        
    // MARK: - Networking
    private func netFavoriteCocktailData() {
        favoriteCocktailViewModel.request()
    }
    
    private func bindNetworkingState() {
        favoriteCocktailViewModel.state.success
            .bind { favoriteCocktailResponse in
                self.indicator.endRefreshing()
                self.consumeSuccess(favoriteCocktailResponse)
        }.disposed(by: disposeBag)
        
        favoriteCocktailViewModel.state.fail
            .bind { _ in
                self.indicator.endRefreshing()
                print("ERROR: favorite cocktail cannot be loaded")
        }.disposed(by: disposeBag)
    }
    
    private func consumeSuccess(_ result: FavoriteCocktailAPIResponse) {
        self.cocktails = result.favoriteCocktailList
        self.cocktailCollectionView.reloadData()
        
        self.isFirstViewLoaded = false
    }
    
    /*func getFavoriteCocktail() {
        guard let url = URL(string: "http://3.36.149.10:55670/api/cocktail/like") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(UserDefaultsManager.token,
                            forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                print("ERROR: cannot connect favorite cocktail url")
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("ERROR: cannnot load favorite cocktail data")
                return
            }
            
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(
                FavoriteCocktailAPIResponse.self,
                from: data) {
                print("favorite cocktail load status: " + json.message)
                
                if json.code == 0 {
                    self.cocktails = json.favoriteCocktailList
                    
                    DispatchQueue.main.async {
                        self.indicator.endRefreshing()
                        self.cocktailCollectionView.reloadData()
                        self.isFirstViewLoaded = false
                    }
                }
            }
        }.resume()
    } */
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
                    as? EmptyFavoriteCocktailCollectionViewCell
            else { return UICollectionViewCell() }

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
        print(self.cocktails)
        let cocktailDetailViewController = CocktailDetailViewController()
        let cocktailInformation: CocktailInfo = CocktailInfo(cocktailId: self.cocktails[indexPath.row].id,
                                                             image: self.cocktails[indexPath.row].image,
                                                             name: self.cocktails[indexPath.row].name,
                                                             alcohol: self.cocktails[indexPath.row].alcohol)
        
        cocktailDetailViewController.cocktailInfo = cocktailInformation
        self.navigation?.pushViewController(cocktailDetailViewController, animated: true)
    }
}
