//
//  SearchPlace.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/19.
//

import SwiftyJSON

class SearchPlace {
    var results = [Place]()
    
    init(_ json: JSON) {
        if let array = json["results"].array {
            results = array.map { Place($0) }
        }
    }
}

struct Place {
    var geometry: Geometry
    var icon = ""
    var name = ""
    var photos = [Photo]()
    var place_id = ""
    var reference = ""
    var types = [String]()
    var vicinity = ""
    
    init(_ json: JSON) {
        geometry = Geometry(json["geometry"])
        icon = json["icon"].stringValue
        name = json["name"].stringValue
        place_id = json["place_id"].stringValue
        reference = json["reference"].stringValue
        vicinity = json["vicinity"].stringValue
        
        if let array = json["photos"].array {
            photos = array.map { Photo($0) }
        }
        
        if let array = json["types"].array {
            types = array.map { String($0.stringValue) }
        }
    }
}

struct Geometry {
    var location: Location
    
    init(_ json: JSON) {
        location = Location(json["location"])
    }
}

struct Location {
    var lat = 0.0
    var lng = 0.0
    
    init(_ json: JSON) {
        lat = json["lat"].doubleValue
        lng = json["lng"].doubleValue
    }
}

struct Photo {
    var height = 0
    var width = 0
    
    init(_ json: JSON) {
        height = json["height"].intValue
        width = json["width"].intValue
    }
}
