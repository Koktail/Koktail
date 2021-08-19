//
//  CocktailDetailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/20.
//

import UIKit

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
    private func getCocktailDetail() {
        guard let url = URL(string:  "http://3.36.149.10:55670/api/cocktail/get/" + String(cocktailInfo!.cocktailId)) else {
            print("url 변환 오류")
            return
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        request.addValue(UserDefaultsManager.token,
                            forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [self]
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }

            let decoder = JSONDecoder()
            do {
                
                let json = try decoder.decode(CocktailDetailJson.self, from: data)
//                print(json)
                
                DispatchQueue.main.async {
                    self.isLiked = json.data!.isLiked
                    setNavigationButton()
                    
                    if let imgURL = json.data?.image{
                        setImgView(imgURL)
                    }
                    
                    self.descriptionLabel.text = json.data?.description
                    self.alcoholDegreeLabel.text = json.data?.alcohol
                    self.baseLabel.text = json.data?.base
                    self.TagLabel.text = "#파티"
                    
                    setSliderValue(slider: sweetSlider, value: json.data!.sweet)
                    setSliderValue(slider: sourSlider, value: json.data!.sour)
                    setSliderValue(slider: bitterSlider, value: json.data!.bitter)
                    setSliderValue(slider: drySlider, value: json.data!.dry)
                    
                    self.ingredientLabel.text = json.data?.material
                    self.recipeLabel.text = json.data?.recipeList.joined(separator: "\n\n")
                }
            } catch {
                print("json 파싱 오류")
            }

        }.resume()
    }
    
    private func setImgView(_ imgURL : String){
        guard let url = URL(string: imgURL) else {
            return
        }
        
        do{
            let data = try Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }catch{
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
        guard let url = URL(string:  "http://3.36.149.10:55670/api/cocktail/like/" + String(cocktailInfo!.cocktailId)) else {
            print("url 변환 오류")
            return
        }
        
        let param = cocktailInfo?.name.data(using: .utf8)
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.addValue(UserDefaultsManager.token,
                            forHTTPHeaderField: "Authorization")
        request.httpBody = param
        
        URLSession.shared.dataTask(with: request) { [self]
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }

            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(CocktailLikeJson.self, from: data)
//                print(json)
                NotificationCenter.default.post(name: .updateFavoriteCocktail, object: nil)
                
            } catch {
                print("json 파싱 오류")
            }

        }.resume()
    }
}
