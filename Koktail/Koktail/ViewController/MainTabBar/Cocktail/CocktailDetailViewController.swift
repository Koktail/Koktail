//
//  CocktailDetailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/20.
//

import UIKit

struct CocktailDetailJson: Codable {
    var code: Int
    var message: String
    var data: CocktailDetailData?
}

struct CocktailDetailData: Codable {
    var cocktailId: UInt64
    var image: String?
    var name: String
    var base: String
    var alcohol: String
    var sour: String
    var sweet: String
    var bitter: String
    var dry: String
    var recipeList: [String]
    var description: String
    var material: String
    var isLiked: Bool
}

class CocktailDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var cocktailInfo: CocktailInfo?
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var alcoholSlider: UISlider!
    @IBOutlet weak var sweetSlider: UISlider!
    @IBOutlet weak var sourSlider: UISlider!
    @IBOutlet weak var bitterSlider: UISlider!
    @IBOutlet weak var drySlider: UISlider!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = cocktailInfo?.name
        
        getCocktailDetail()
    }
    
    // MARK: - Custom Methods
    func getCocktailDetail() {
        guard let url = URL(string: "http://3.36.149.10:55670/api/cocktail/get/" + String(cocktailInfo!.cocktailId)) else {
            print("url 변환 오류")
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        // TODO: header 추가

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
                
                let json = try decoder.decode(CocktailDetailJson.self, from: data)
                print(json)
                
                DispatchQueue.main.async {
                    self.descriptionLabel.text = json.data?.description
                }
            
            }catch{
                print("json 파싱 오류")
            }

        }.resume()
    }
    
}

