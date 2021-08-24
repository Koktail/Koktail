//
//  CocktailDetailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/20.
//

import UIKit
import Alamofire

class CocktailDetailViewController: UIViewController {
    
    // MARK: - Properties
    var cocktailInfo: CocktailInfo?
    var isLiked: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var alcoholDegreeLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var TagLabel: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor =
            UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        
    }
    
    // MARK: - Custom Methods
    func getCocktailDetail(){
        
        let url = "http://3.36.149.10:55670/api/cocktail/get/\( cocktailInfo!.cocktailId)"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json",  "Accept": "application/json", "Authorization": UserDefaultsManager.token])
                .responseJSON {(response) in
                    
                    switch response.result {
                    case .success:
                        guard let result = response.data else {
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(CocktailDetailJson.self, from: result)
                            
                            DispatchQueue.main.async {
                                self.isLiked = json.data!.isLiked
                                self.setNavigationButton()
                                
                                if let imgURL = json.data?.image {
                                    self.setImgView(imgURL)
                                }
                                
                                self.descriptionLabel.text = json.data?.description
                                self.alcoholDegreeLabel.text = json.data?.alcohol
                                self.baseLabel.text = json.data?.base
                                self.TagLabel.text = "#파티"
                                
                                self.setSliderValue(slider: self.sweetSlider, value: json.data!.sweet)
                                self.setSliderValue(slider: self.sourSlider, value: json.data!.sour)
                                self.setSliderValue(slider: self.bitterSlider, value: json.data!.bitter)
                                self.setSliderValue(slider: self.drySlider, value: json.data!.dry)
                                
                                self.ingredientLabel.text = json.data?.material
                                self.recipeLabel.text = json.data?.recipeList.joined(separator: "\n\n")
                            }
                        } catch {
                            print("json 파싱 오류")
                        }

                    default:
                        break
                    }
            }
    }
    
    private func setImgView(_ imgURL: String) {
        guard let url = URL(string: imgURL) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        } catch {
            return
        }
    }
    
    private func setSliderValue(slider: UISlider, value: String) {
        switch value {
        case "HIGH":
            slider.value = 1
        case "MID":
            slider.value = 0.5
        case "LOW":
            slider.value = 0
        default:
            break
        }
    }
    
    private func setNavigationButton() {
        let likeButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain, target: self,
            action: #selector(likeButtonAction(_: )))
        likeButtonItem.tintColor = UIColor.black
        
        if self.isLiked {
            likeButtonItem.image = UIImage(systemName: "heart.fill")
            likeButtonItem.tintColor = UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
        }
        
        navigationItem.rightBarButtonItem = likeButtonItem
    }
    
    @objc private func likeButtonAction(_ sender: UIBarButtonItem) {
        if self.isLiked {
            isLiked = false
            sender.image = UIImage(systemName: "heart")
            sender.tintColor = UIColor.black
            postCocktailLike()
        } else {
            isLiked = true
            sender.image = UIImage(systemName: "heart.fill")
            sender.tintColor = UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
            postCocktailLike()
            
        }
    }
    
    private func postCocktailLike() {
        
        let url = "http://3.36.149.10:55670/api/cocktail/like/\(cocktailInfo!.cocktailId)"
        
        let params = ["name": cocktailInfo?.name.data(using: .utf8)]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json",  "Accept": "application/json", "Authorization": UserDefaultsManager.token])
                .responseJSON {
                    (response) in
            }
    }
}
