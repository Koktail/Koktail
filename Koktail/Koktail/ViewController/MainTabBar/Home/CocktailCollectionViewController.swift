//
//  CocktailCollectionViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/02.
//

import UIKit

private let reuseIdentifier = "Cell"

class CocktailCollectionViewController: UICollectionViewController {
    var imageArray = [UIImage(named: "test_Image_Cocktail"), UIImage(named: "test_Image_Cocktail"),
                      UIImage(named: "test_Image_Cocktail"), UIImage(named: "test_Image_Cocktail"),
                      UIImage(named: "test_Image_Cocktail"), UIImage(named: "test_Image_Cocktail"),
                      UIImage(named: "test_Image_Cocktail")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let nibName = UINib(nibName: "CocktailCollectionViewCell", bundle: nil)
//        collectionView.register(nibName, forCellReuseIdentifier: "cocktailCell")
        collectionView.register(nibName, forCellWithReuseIdentifier: "cocktailCell")

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

//    override func collectionView(_ collectionView: UICollectionView,
//                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//    
//        // Configure the cell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCell", for: indexPath)
//            as! CocktailCollectionViewCell
//        print("HI")
//        cell.cocktailImg.image = imageArray[indexPath.row]
//        cell.cocktailImg.layer.borderWidth = 1
//        cell.cocktailImg.layer.borderColor = UIColor.gray.cgColor
////        cell.view.layer.borderColor = UIColor.gray.cgColor
////        cell.view.layer.borderWidth = 0.1
////        cell.view.layer.cornerRadius = 20
////        cell.view.layer.shadowColor = UIColor.gray.cgColor
////        cell.view.layer.shadowOpacity = 1.0
////        cell.view.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
////        cell.view.layer.shadowRadius = 2
//        
//        cell.cocktailName.text = "모히또"
//        cell.cocktailDegree.text = "Alc 12.6"
//        return cell
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView,
     shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item,
     and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView,
     shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView,
     canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView,
     performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}
