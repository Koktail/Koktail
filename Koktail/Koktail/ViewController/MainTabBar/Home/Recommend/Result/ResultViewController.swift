//
//  ResultViewController.swift
//  xib_result
//
//  Created by 형주 on 2021/07/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var imageArray = [UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail")]
    
    var resultName: [String]?
    var resultDescription: [String]?
    var resultAlcohol: [String]?
    var resultID: [Int] = []
    var resultImage: [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var againButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CocktailResultTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        tableView.register(UINib(nibName: "NoResultTableViewCell", bundle: nil), forCellReuseIdentifier: "NoCell")
        tableView.bounces = tableView.contentOffset.y > 100
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        setAgainButton()
        setNavigationBar()
        ResultAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(red: 209.0/255.0, green: 122.0/255.0, blue: 108.0/255.0, alpha: 1.0)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultID.count == 0 {
            return 2
        }
        guard let idx = self.resultName?.count else {return 2}
        return idx + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resultID == [] {
            print("hi")
            if indexPath.row == 0 {
                let cell: HeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell1")
                    as! HeaderTableViewCell
                cell.layer.frame.size.height = 300
                cell.headerBar.roundCorners(corners: [.topLeft, .topRight], radius: 20)
                cell.headerBar.addShadow(offset: CGSize(width: 0, height: -4))
                return cell
            } else {
                print("UUU")
                let cell: NoResultTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "NoCell")
                    as! NoResultTableViewCell
                cell.layer.frame.size.height = 100
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell: HeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell1")
                    as! HeaderTableViewCell
                cell.layer.frame.size.height = 300
                cell.headerBar.roundCorners(corners: [.topLeft, .topRight], radius: 20)
                cell.headerBar.addShadow(offset: CGSize(width: 0, height: -4))
                return cell
            } else {
                let cell: CocktailResultTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as! CocktailResultTableViewCell
                cell.CocktailImage?.image = UIImage(named: "cocktail")
                cell.CocktailInfo?.text = "단맛, 과일, 높은 도수"
                if self.resultName?.count != 0 {
                    cell.CocktailName.text = self.resultName?[indexPath.row - 1]
                    
                    switch self.resultAlcohol?[indexPath.row - 1] {
                    case "HIGH":
                        cell.CocktailAlc.text = "도수 : 🤪(상)"
                    case "MID":
                        cell.CocktailAlc.text = "도수 : 🤤(중)"
                    case "LOW":
                        cell.CocktailAlc.text = "도수 : 🙂(하)"
                    default:
                        break
                    }
                }
                cell.CocktailImage.applyshadowWithCorner(containerView: cell.Imageview, cornerRadious: 30)
                
                return cell
            
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultID.count == 0 {
            return
        }
        let vc = CocktailDetailViewController()
        let cocktail: CocktailInfo = CocktailInfo(cocktailId: UInt64(resultID[indexPath.row - 1]),
                                                  image: "null", name: resultName?[indexPath.row - 1] ?? "null",
                                                  alcohol: resultAlcohol?[indexPath.row - 1] ?? "null"
                                                  )
        vc.cocktailInfo = cocktail
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func ResultAPI() {
        let resultURL = "http://3.36.149.10:55670/api/cocktail/favorite?" +
            "base=\(base)&alcohol=\(alcohol)&sour=\(sour)&sweet=\(sweet)&bitter=\(bitter)&dry=\(dry)"
        AF.request(resultURL,
                   method: .get).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        self.resultName = []
                        self.resultDescription = []
                        self.resultAlcohol = []
                        if let cocktailArray = json["data"].array {
                            for i in 0..<cocktailArray.count {

                                if let name = cocktailArray[i]["name"].string {
                                    self.resultName?.append(name)
                                }

                                if let alcohol = cocktailArray[i]["alcohol"].string {
                                    self.resultAlcohol?.append(alcohol)
                                }
                                
                                if let id = cocktailArray[i]["cocktailId"].int {
                                    print(id)
                                    self.resultID.append(id)
                                }
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(_):
                        return
                    }
                  
                })
                
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setAgainButton() {
        againButton.layer.cornerRadius = againButton.frame.height / 2
    }
    
    @IBAction func againButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: false)
        let vc = SelectPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,
                                          navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                          options: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 3.0) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = radius
        }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
           
            self.layer.maskedCorners = masked
        } else {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

extension UIImageView {
    func applyshadowWithCorner(containerView: UIView, cornerRadious: CGFloat) {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds,
                                                      cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
