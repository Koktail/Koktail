//
//  MoreCocktailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/15.
//

import UIKit

class MoreCocktailViewController: UIViewController {
    
    // MARK: - Properties
    private let previews: [String:[String]] = [
        "보드카" : ["블러디 메리", "치치", "블랙 러시안", "스크류 드라이버"],
        "리큐르" : ["그라스 호퍼", "준벅", "미도리 사워", "깔루아 밀크"],
        "럼" : ["바카디", "마이티이", "블루 하와이", "피나 콜라다"],
        "데킬라" : ["마가리타", "데킬라 선라이즈"],
        "위스키" : ["갓 파더", "맨하탄"],
        "진" : ["진토닉", "롱 아일랜드 아이스티", "싱가폴 슬링", "마티니"],

        "무알콜" : ["모히또"],
        "😋" : ["마이티이", "깔루아 밀크", "피나 콜라다"],
        "🤤" : ["블러디 메리", "그라스 호퍼", "치치", "준벅", "미도리 사워", "진토닉", "싱가폴 슬링", "블루 하와이", "마가리타", "데킬라 선라이즈"],
        "🤪" : ["바카디", "롱 아일랜드 아이스티", "블랙 러시안", "스크류 드라이버", "갓 파더", "맨하탄"],

        "sweet" : ["블러디 메리", "그라스 호퍼", "치치", "준벅", "미도리 사워", "바카디", "마이티이", "롱 아일랜드 아이스티", "블랙 러시안", "싱가폴 슬링", "스크류 드라이버", "블루 하와이", "데킬라 선라이즈", "깔루아 밀크", "피나 콜라다"],
        "sour" : ["준벅", "미도리 사워", "바카디", "진토닉", "롱 아일랜드 아이스티", "싱가폴 슬링", "스크류 드라이버", "마가리타"],
        "bitter" : ["진토닉", "갓 파더"],
        "dry" : ["맨하탄"]
        ]
    
    var navigation: UINavigationController?
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
        
        return previews[categoryName!]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCocktailTableViewCell", for: indexPath) as! MoreCocktailTableViewCell
        
        cell.imgView!.image = UIImage(named: "cosmopolitan.jpeg")
        cell.cocktailNameLabel!.text =  previews[categoryName!]![indexPath.row]
        cell.cocktailInfoLabel!.text = "도수 | 베이스 | 상황"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let detailVC = DetailViewController()
//
//        detailVC.cocktailName = "코스모폴리탄"
//
//        navigation?.pushViewController(detailVC, animated: true)
    }
}
