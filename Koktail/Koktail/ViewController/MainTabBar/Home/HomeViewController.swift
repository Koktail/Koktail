//
//  HomeViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/06/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {
    var imageArray: [String] = []
    var apiResponseName: [String]?
    var apiResponseAlchol: [String]?
    var apiResponseImage: [String] = []
    var apiResponseID: [Int] = []
    let semaphore = DispatchSemaphore(value: 0)
    var todayCocktailName: String?
    var todayCocktailId: Int?
    var todayCocktailAlcohol :String?
    
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var todayCocktail: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeAPI()
        setRightNavigationButton()
        setNavigationBar()
        setRecommendButton()
        setTodayCocktail()
        setCollectionView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        setRightNavigationButton()
        setNavigationBar()
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
    
    @IBAction func RecommendAction(_ sender: UIButton) {
        let vc = SelectPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,
                                          navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                          options: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeAPI() {
        AF.request("http://3.36.149.10:55670/api/cocktail/home",
                   method: .get).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.todayCocktailId = json["data"]["todayCocktail"]["cocktailId"].int
                        self.todayCocktailName = json["data"]["todayCocktail"]["name"].string
                        self.todayCocktailAlcohol = json["data"]["todayCocktail"]["alcohol"].string
                        if let todayImage = json["data"]["todayCocktail"]["image"].string {
                            OperationQueue().addOperation {
                                let url = URL(string: todayImage)
                                let data = try? Data(contentsOf: url!)
                                OperationQueue.main.addOperation {
                                    self.todayCocktail.image = UIImage(data: data!)
                                    self.todayCocktail.roundCorners(corners: [.topLeft, .topRight,
                                                                              .bottomLeft, .bottomRight],
                                                                    radius: 20)
                                }
                            }
                        }
                        print(json)
                        if let cocktailArray = json["data"]["cocktail"].array {
                            self.apiResponseName = []
                            self.apiResponseAlchol = []
                            for i in 0..<cocktailArray.count {
                                if let name = cocktailArray[i]["name"].string {
                                    self.apiResponseName?.append(name)
                                }
                                
                                if let alcohol = cocktailArray[i]["alcohol"].string {
                                    self.apiResponseAlchol?.append(alcohol)
                                }
                                if let id = cocktailArray[i]["cocktailId"].int {
                                    self.apiResponseID.append(id)
                                }
                                if let img = cocktailArray[i]["image"].string {
                                    self.imageArray.append(img)
                                }
                            }
                            self.collectionView.reloadData()
                        }
                    case .failure(_):
                        return
                    }
                  
                })
        self.collectionView.reloadData()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "홈화면"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
    }
    
    func setCollectionView() {
        let nibName = UINib(nibName: "CocktailCollectionViewCell", bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "cocktailCell")
    }
    
    func setRecommendButton() {
        self.recommendBtn.backgroundColor = UIColor.white
        self.recommendBtn.layer.cornerRadius = 20
        self.recommendBtn.layer.shadowColor = UIColor.gray.cgColor
        self.recommendBtn.layer.shadowOpacity = 1.0
        self.recommendBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.recommendBtn.layer.shadowRadius = 1.5
    }
    
    func setTodayCocktail() {
        let heightConstraint = NSLayoutConstraint(item: todayCocktail!, attribute: .height,
                                                  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                  multiplier: 1.0, constant: self.view.frame.height * 0.5)
        let widthConstraint = NSLayoutConstraint(item: todayCocktail!, attribute: .width,
                                                 relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                 multiplier: 1.0, constant: self.view.frame.height * 0.5)
        self.todayCocktail.addConstraints([heightConstraint, widthConstraint])
        self.todayCocktail.isUserInteractionEnabled = true
        let event = UITapGestureRecognizer(target: self, action: #selector(self.touchToPickPhoto))
        self.todayCocktail.addGestureRecognizer(event)
        
    }
    
    @objc func touchToPickPhoto() {
        let detailVC = CocktailDetailViewController()
        let cocktail: CocktailInfo = CocktailInfo(cocktailId: UInt64(todayCocktailId ?? 0),
                                                  image: "null",
                                                  name: todayCocktailName ?? "null",
                                                  alcohol: todayCocktailAlcohol ?? "10"
                                                  )
        detailVC.cocktailInfo = cocktail

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cocktailCell", for: indexPath)
            as! CocktailCollectionViewCell
        if self.apiResponseName?.count != 0 {
            cell.cocktailName.text = self.apiResponseName?[indexPath.row]
            
            switch self.apiResponseAlchol?[indexPath.row] {
            case "HIGH":
                cell.cocktailDegree.text = "도수 : 🤪(상)"
            case "MID":
                cell.cocktailDegree.text = "도수 : 🤤(중)"
            case "LOW":
                cell.cocktailDegree.text = "도수 : 🙂(하)"
            default:
                break
            }

        }
        OperationQueue().addOperation {
            let url = URL(string: self.imageArray[indexPath.row])
            let data = try? Data(contentsOf: url!)
            OperationQueue.main.addOperation {
                cell.cocktailImg.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.apiResponseImage)
        let detailVC = CocktailDetailViewController()
        let cocktail: CocktailInfo = CocktailInfo(cocktailId: UInt64(apiResponseID[indexPath.row]),
                                                  image: imageArray[indexPath.row],
                                                  name: apiResponseName?[indexPath.row] ?? "null",
                                                  alcohol: apiResponseAlchol?[indexPath.row] ?? "null"
                                                  )
        detailVC.cocktailInfo = cocktail

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
