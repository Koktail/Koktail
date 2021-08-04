//
//  FavoriteCocktail.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/03.
//

import Foundation

struct FavoriteCocktailAPIResponse: Codable {
    let code: Int
    let message: String
    var favoriteCocktailList: [Cocktail]
    
    enum CodingKeys: String, CodingKey {
        case favoriteCocktailList = "data"
        case code, message
    }
}

struct Cocktail: Codable {
    let id: UInt64
    var image: String?
    let name: String
    let alcohol: String
    
    enum CodingKeys: String, CodingKey {
        case id = "cocktailId"
        case image, name, alcohol
    }
    
    var fullAlcohol: String {
        return "Alc" + alcohol
    }
}
