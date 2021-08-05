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
    private lazy var notExistFavoriteCocktail =
        NotExistFavoriteCocktail(frame: self.view.frame)
    
    var cocktails: [Cocktail] = []
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        
        getFavoriteCocktail()
        // initCocktail()
        
        // checkFavoriteCocktailExist()
    }
    
    // MARK: - Set Collection View
    private func setCollectionView() {
        cocktailCollectionView.delegate = self
        cocktailCollectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2.5
        let height = UIScreen.main.bounds.height / 4
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 60, right: 20)
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        cocktailCollectionView.register(
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
                }
            }
        }.resume()
    }
    
    // MARK: - Test Method
    func initCocktail() {
        for idx in 1...9 {
            let cocktail = Cocktail.init(id: UInt64(idx), image: "", name: "test\(idx) name", alcohol: "14.5")
            self.cocktails.append(cocktail)
        }
    }
    
    // MARK: Custom Method
    func checkFavoriteCocktailExist() {
        if cocktails.count == 0 {
            self.cocktailCollectionView.addSubview(notExistFavoriteCocktail)
            
            notExistFavoriteCocktail.snp.makeConstraints { make in
                make.height.equalTo(self.view).offset(-20)
                make.width.equalTo(self.view).offset(-20)
            }
        }
    }
}

// MARK: - Collection View
extension FavoriteCocktailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
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
}

// MARK: - support UIView
class NotExistFavoriteCocktail: UIView {
    // MARK: SubView
    let makeFavoriteCocktailLabel: UILabel = {
        let label = UILabel()
        label.text = "마음에 드는 칵테일을 찜해보세요 💓"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        makeFavoriteCocktailLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
