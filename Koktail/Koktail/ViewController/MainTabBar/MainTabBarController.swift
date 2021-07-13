//
//  MainTabBarController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import Then

class MainTabBarController: UITabBarController {

    // MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        setTabBarItem()
    }
    
    // MARK: Set Item
    func setTabBarItem() {
        
        // 홈화면
        let homeTabItem = UITabBarItem(
            title: "홈화면",
            image: UIImage(named: " "),
            selectedImage: UIImage(named: " ")
        )
        
        let home = UINavigationController(rootViewController: HomeViewController()).then {
            $0.tabBarItem = homeTabItem
            $0.tabBarItem.tag = 0
        }
        
        // 칵테일
        let cocktailTabItem = UITabBarItem(
            title: "칵테일",
            image: UIImage(named: " "),
            selectedImage: UIImage(named: " ")
        )
        
        let cocktail = UINavigationController(rootViewController: CocktailViewController()).then {
            $0.tabBarItem = cocktailTabItem
            $0.tabBarItem.tag = 1
        }
        
        // 지도
        let mapTabItem = UITabBarItem(
            title: "지도",
            image: UIImage(named: " "),
            selectedImage: UIImage(named: " ")
        )
        
        let map = UINavigationController(rootViewController: MapViewController()).then {
            $0.tabBarItem = mapTabItem
            $0.tabBarItem.tag = 2
        }
        
        // 찜 목록
        let favoriteTabItem = UITabBarItem(
            title: "찜목록",
            image: UIImage(named: " "),
            selectedImage: UIImage(named: " ")
        )
        
        let favorite = UINavigationController(rootViewController: FavoriteViewController()).then {
            $0.tabBarItem = favoriteTabItem
            $0.tabBarItem.tag = 3
        }
        
        self.viewControllers = [
            home,
            cocktail,
            map,
            favorite
        ]
    }

}
