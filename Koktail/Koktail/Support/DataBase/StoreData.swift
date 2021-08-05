//
//  StoreData.swift
//  Koktail
//
//  Created by 최승명 on 2021/08/02.
//

import RealmSwift

class StoreData: Object {
    @objc dynamic var store_title = ""
    @objc dynamic var store_website = ""
    @objc dynamic var store_phone = ""
    @objc dynamic var store_address = ""
    @objc dynamic var store_rating = ""
    @objc dynamic var store_flag = false
}
