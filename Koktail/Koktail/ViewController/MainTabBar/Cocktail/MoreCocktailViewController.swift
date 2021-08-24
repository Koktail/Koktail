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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
    }
}

extension MoreCocktailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "moreCocktailTableViewCell",
            for: indexPath
        ) as! MoreCocktailTableViewCell
        
        cell.setTableViewCell(cocktails[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailVC = CocktailDetailViewController()

        detailVC.cocktailInfo = cocktails[indexPath.row]

        navigation?.pushViewController(detailVC, animated: true)
    }
}
