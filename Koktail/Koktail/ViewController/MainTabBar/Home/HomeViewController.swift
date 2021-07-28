//
//  HomeViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit

class HomeViewController: UIViewController {
    var imageArray = [UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail")]
    
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var todayCocktail: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print("================================")
        print(UserDefaultsManager.userId)
        print(UserDefaultsManager.social)
        print(UserDefaultsManager.token)
        setRightNavigationButton()
        self.navigationItem.title = "홈화면"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 199.0/255.0, green: 116.0/255.0, blue: 104.0/255.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: "CocktailCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "cocktailCell")

        recommendBtn.backgroundColor = UIColor.white
        recommendBtn.layer.cornerRadius = 20
        recommendBtn.layer.shadowColor = UIColor.gray.cgColor
        recommendBtn.layer.shadowOpacity = 1.0
        recommendBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        recommendBtn.layer.shadowRadius = 1.5
        
        let heightConstraint = NSLayoutConstraint(item: todayCocktail, attribute: .height,
                                                  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.height * 0.5)
        let widthConstraint = NSLayoutConstraint(item: todayCocktail, attribute: .width,
                                                 relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.height * 0.5)
        self.todayCocktail.addConstraints([heightConstraint, widthConstraint])

    }
    
    // MARK: - Set Navigation
    private func setRightNavigationButton() {
        let settingButtonItem = UIBarButtonItem(
            image: UIImage(named: "setting_button"),
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(barButtonTap(sender:))
        )
        settingButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    // MARK: - objc Action
    @objc func barButtonTap(sender: UIBarButtonItem) {
        let settingTableViewController = SettingViewController()
        settingTableViewController.hidesBottomBarWhenPushed = true
        
        guard let navigation = self.navigationController else { return }
        navigation.pushViewController(settingTableViewController, animated: true)
    }
    
    @IBAction func RecommendAction(_ sender: UIButton){
        let vc = SelectPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,
                                          navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                          options: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCell", for: indexPath)
            as! CocktailCollectionViewCell
//        print("HI")
        cell.cocktailImg.image = imageArray[indexPath.row]
        cell.cocktailImg.layer.cornerRadius = 20
        cell.view.layer.borderColor = UIColor.gray.cgColor
        cell.view.layer.borderWidth = 0.1
        cell.view.layer.cornerRadius = 20
        cell.view.layer.shadowColor = UIColor.gray.cgColor
        cell.view.layer.shadowOpacity = 1.0
        cell.view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        cell.view.layer.shadowRadius = 2
        cell.cocktailName.text = "모히또"
        cell.cocktailDegree.text = "Alc 12.6"
        return cell
    }
}
