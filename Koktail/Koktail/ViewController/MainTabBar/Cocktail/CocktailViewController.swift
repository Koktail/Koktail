//
//  CocktailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit

class CocktailViewController: UIViewController {
    
    // MARK: - Properties
    private var cocktailList:[String:[CocktailInfo]] = [:]
    
    // MARK: - Outlets
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
        navigationController?.navigationBar.isHidden = true
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)], for: .selected)
        segmentedControl.roundCorners(corners: UIRectCorner.init(), radius: 20)
        
    }
    
    // MARK: - Custom Methods
    func getCocktailList(type: String) {
        guard let url = URL(string: "http://3.36.149.10:55670/api/cocktail/list?type=" + type) else {
            print("url 변환 오류")
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [self]
            (data, response, error) in
            
            if error != nil {
                print("http error")
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }

            let decoder = JSONDecoder()
            do{
                let json = try decoder.decode(CocktailListJson.self, from: data)
                
                var cocktailListTemp: [String:[CocktailInfo]] = [:]
                for category in json.data{
                    cocktailListTemp[category.value] = category.cocktailList
                }
                
                self.cocktailList = cocktailListTemp
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch{
                print("json 파싱 오류")
            }

        }.resume()
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
