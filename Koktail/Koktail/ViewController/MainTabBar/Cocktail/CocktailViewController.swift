//
//  CocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import Alamofire

class CocktailViewController: UIViewController {
    
    // MARK: - Properties
    private var cocktailList:[String:[CocktailInfo]] = [:]
    
    // MARK: - Outlets
    @IBOutlet weak var topSubView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Actions
    @IBAction func changeSegmentAction(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getCocktailList(type: "base")
        case 1:
            getCocktailList(type: "tag")
        case 2:
            getCocktailList(type: "level")
        default:
            break
        }
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "categoryTableViewCell")
        
        getCocktailList(type: "base")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        topSubView.backgroundColor = UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
        
        setSegmentedControl()
    }
    
    // MARK: - Custom Methods
    func getCocktailList(type: String){
        
        let url = "http://3.36.149.10:55670/api/cocktail/list?type=" + type
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .responseJSON {
                    (response) in
                    
                    switch response.result {
                    case .success:
                        guard let result = response.data else {
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(CocktailListJson.self, from: result)
                            
                            
                            var cocktailCategoryList: [String:[CocktailInfo]] = [:]
                            for category in json.data{
                                cocktailCategoryList[category.value] = category.cocktailList
                            }
                            self.cocktailList = cocktailCategoryList
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        } catch {
                            print("decoding error")
                        }

                    default:
                        break
                    }
            }
    }

    
    private func setSegmentedControl(){
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(red: 246/255, green: 121/255, blue: 115/255, alpha: 1.0)], for: .selected)
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.setBackgroundImage(UIImage.init(), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(named: "segmentedControlResource"), for: .selected, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.addShadow(offset: CGSize(width: 0, height: 0), color: .clear, opacity: 0.0, radius: 0)
    }
}

extension CocktailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cocktailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath)
            as! CategoryTableViewCell
        
        cell.navigation = self.navigationController
        
        cell.categoryLabel!.text = cocktailList.keys.sorted()[indexPath.row]
        
        cell.previews = cocktailList[cocktailList.keys.sorted()[indexPath.row]]!
        
        cell.previewCollectionView.reloadData()
        
        return cell
    }
}
