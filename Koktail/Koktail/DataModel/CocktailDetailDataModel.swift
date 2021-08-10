//
//  CocktailDetailDataModel.swift
//  Koktail
//
//  Created by 김유진 on 2021/08/10.
//

import Foundation

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
    var isLiked: Bool = false
}
