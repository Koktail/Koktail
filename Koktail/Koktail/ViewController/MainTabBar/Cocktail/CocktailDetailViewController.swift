//
//  CocktailDetailViewController.swift
//  Koktail
//
//  Created by 김유진 on 2021/07/20.
//

import UIKit

class CocktailDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var cocktailName: String?
    
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
        
        title = cocktailName
        
        descriptionLabel!.text = """
            보드카 베이스로, 카미카제에 크랜베리 주스를 추가한 형태의 변형 칵테일.
            맛은 크랜베리, 오렌지, 라임이 재료로 들어가 달면서도 산뜻하며 복합적인 맛을 낸다.
            역사는 길지만 최근 섹스 앤 더 시티에 주인공 캐리 브래드쇼가 좋아하는 칵테일로 등장해 유명세를 탔다.
            레이디 킬러 칵테일 중 하나.
            크랜베리 주스의 투명하고 예쁜 선홍빛 색, 과실즙의 달고 향긋한 맛 때문에 처음 마시는 사람은 멋도 모르고 쭉 들이킬 수 있지만, 그런 달콤한 맛에 비해 도수가 20도가 넘어가기 때문에 바에서 이 술을 누군가가 권한다면 한번쯤은 생각해 보는 것이 좋다.
            """
        
        imageView!.image = UIImage(named: "cosmopolitan")
        alcoholSlider!.value = 0.5
        sweetSlider!.value = 1
        sourSlider!.value = 0.5
        bitterSlider!.value = 0
        drySlider!.value = 0
        ingredientLabel!.text = "보드카 1oz, 트리플 섹 1/2oz, 라임 주스 1/2oz, 크랜베리 주스 1/2oz"
        recipeLabel!.text = """
            1. 모든 재료들을 모두 섞는다.
            2. 더블 스트레인해 마티니 글라스에 따라준다.
            3. 라임 슬라이스로 장식한다.
            """
        
    }
    
}

