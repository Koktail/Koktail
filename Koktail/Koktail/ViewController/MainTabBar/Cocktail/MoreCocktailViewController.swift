//
//  MoreCocktailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/15.
//

import UIKit

class MoreCocktailViewController: UIViewController {
    
    // MARK: - Properties
    var navigation: UINavigationController?
    var cocktails: [CocktailInfo] = []
    var categoryName: String?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "MoreCocktailTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "moreCocktailTableViewCell")
        
        title = categoryName
    }
}

extension MoreCocktailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCocktailTableViewCell", for: indexPath) as! MoreCocktailTableViewCell
        
        cell.imgView!.image = UIImage(named: "cosmopolitan.jpeg")
        cell.cocktailNameLabel!.text = cocktails[indexPath.row].name
        switch cocktails[indexPath.row].alcohol {
        case "HIGH":
            cell.cocktailInfoLabel.text = "도수 : 🤪(상)"
        case "MID":
            cell.cocktailInfoLabel.text = "도수 : 🤤(중)"
        case "LOW":
            cell.cocktailInfoLabel.text = "도수 : 🙂(하)"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = CocktailDetailViewController()

        detailVC.cocktailInfo = cocktails[indexPath.row]

        navigation?.pushViewController(detailVC, animated: true)
    }
}
