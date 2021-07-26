//
//  PlaceDetail.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import SwiftyJSON

class PlaceDetail {
    var result: Detail
    
    init(_ json: JSON) {
        result = Detail(json["result"])
    }
}

struct Detail {
    var formatted_address = ""
    var formatted_phone_number = ""
    var geometry: Geometry
    var icon = ""
    var name = ""
    var rating = 0.0
    var place_id = ""
    var reference = ""
    var website = ""
    var url = ""
    var types = [String]()
    var reviews = [Review]()
    
    init(_ json: JSON) {
        formatted_address = json["formatted_address"].stringValue
        formatted_phone_number = json["formatted_phone_number"].stringValue
        geometry = Geometry(json["geometry"])
        icon = json["icon"].stringValue
        name = json["name"].stringValue
        rating = json["rating"].doubleValue
        place_id = json["place_id"].stringValue
        reference = json["reference"].stringValue
        website = json["website"].stringValue
        url = json["url"].stringValue
        
        if let array = json["types"].array {
            types = array.map { String($0.stringValue) }
        }
        
        if let array = json["reviews"].array {
            reviews = array.map { Review($0) }
        }
    }
}

struct Review {
    var author_name = ""
    var author_url = ""
    var profile_photo_url = ""
    var rating = 0.0
    var relative_time_description = ""
    var text = ""
    
    init(_ json: JSON) {
        author_name = json["author_name"].stringValue
        author_url = json["author_url"].stringValue
        profile_photo_url = json["profile_photo_url"].stringValue
        rating = json["rating"].doubleValue
        relative_time_description = json["relative_time_description"].stringValue
        text = json["text"].stringValue
    }
}
