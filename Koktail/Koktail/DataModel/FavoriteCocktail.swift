//
//  FavoriteCocktail.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/03.
//

import SwiftyJSON

struct FavoriteCocktailAPIResponse {
    let code: Int
    let message: String
    var favoriteCocktailList = [Cocktail]()
    
    init(_ json: JSON) {
        code = json["code"].intValue
        message = json["message"].stringValue
        
        if let array = json["data"].array {
            favoriteCocktailList = array.map { Cocktail($0) }
        }
    }
}

struct Cocktail {
    let id: UInt64
    var image: String?
    let name: String
    let alcohol: String
    
    init(_ json: JSON) {
        id = json["cocktailId"].uInt64Value
        image = json["image"].stringValue
        name = json["name"].stringValue
        alcohol = json["alcohol"].stringValue
    }
    
    var fullAlcohol: String {
        var fullString: String = "도수: "
        
        switch alcohol {
        case "LOW":
            fullString += "🙂(하)"
        case "MID":
            fullString += "🤤(중)"
        case "HIGH":
            fullString += "🤪(상)"
        default:
            fullString += "NONE"
        }
        
        return fullString
    }
}
