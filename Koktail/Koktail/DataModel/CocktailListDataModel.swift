//
//  CocktailListDataModel.swift
//  Koktail
//
//  Created by 김유진 on 2021/08/10.
//

import Foundation

struct CocktailListJson: Codable {
    var code: Int
    var message: String
    var data: [CocktailData]
}

struct CocktailData: Codable {
    var value: String
    var cocktailList: [CocktailInfo]
}

struct CocktailInfo: Codable {
    var cocktailId: UInt64
    var image: String?
    var name: String
    var alcohol: String
}
