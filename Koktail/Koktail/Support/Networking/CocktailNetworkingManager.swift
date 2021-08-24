//
//  CocktailNetworkingManager.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/24.
//

import Moya
import Alamofire

public enum CocktailNetworkingManger {
    case favoriteCocktail
}

extension CocktailNetworkingManger: TargetType {
    
    public static var parameter = Parameters()
    
    public var baseURL: URL {
        return URL(string: "http://3.36.149.10:55670/api")!
    }
    
    public var path: String {
        switch self {
        case .favoriteCocktail:
            return "/cocktail/like"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .favoriteCocktail: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestParameters(
                parameters: NetworkingManager.parameter,
                encoding: URLEncoding.default
            )
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": UserDefaultsManager.token]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
