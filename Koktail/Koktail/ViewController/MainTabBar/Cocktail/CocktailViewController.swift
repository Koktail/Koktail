//
//  CocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit

class CocktailViewController: UIViewController {
    
    // MARK: - Properties
    private let categories:[String:[String]] = [
        "Base" : ["보드카", "리큐르", "럼", "데킬라", "위스키", "진"],
        "Alcohol Degree" :["무알콜", "😋", "🤤", "🤪"],
        "Taste" : ["sweet", "sour", "bitter", "dry"]]
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func changeSegmentAction(_ sender: UISegmentedControl) {
        tableView.reloadData()
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "categoryTableViewCell")
        
        tableView.reloadData()
    }
}

extension CocktailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return categories["Base"]!.count
        case 1:
            return categories["Alcohol Degree"]!.count
        case 2:
            return categories["Taste"]!.count
        default:
            break
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath)
            as! CategoryTableViewCell
        
        cell.navigation = self.navigationController
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.categoryLabel!.text = categories["Base"]![indexPath.row]
        case 1:
            cell.categoryLabel!.text = categories["Alcohol Degree"]![indexPath.row]
        case 2:
            cell.categoryLabel!.text = categories["Taste"]![indexPath.row]
        default:
            break
        }
        
        cell.previewCollectionView.reloadData()
        
        return cell
    }
    
}
