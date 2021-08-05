//
//  UserDefaultsManager.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/15.
//

import Foundation

struct UserDefaultsManager {
    private static let USERDEFAULTS: UserDefaults = UserDefaults.standard
    
    static var userId: String {
        get {
            return USERDEFAULTS.string(forKey: "user_id") ?? ""
        }
        set(newId) {
            USERDEFAULTS.set(newId, forKey: "user_id")
        }
    }
    
    static var social: String {
        get {
            return USERDEFAULTS.string(forKey: "social") ?? ""
        }
        set(newSocial) {
            USERDEFAULTS.set(newSocial, forKey: "social")
        }
    }
    
    static var token: String {
        get {
            return USERDEFAULTS.string(forKey: "token") ?? ""
        }
        set(newToken) {
            USERDEFAULTS.set(newToken, forKey: "token")
        }
    }
}
