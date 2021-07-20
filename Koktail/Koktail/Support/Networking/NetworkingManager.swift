//
//  NetworkingManager.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/19.
//

import Moya
import Alamofire

public enum NetworkingManager {
    case place
}

extension NetworkingManager: TargetType {

    public static var parameter = Parameters()

    public var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api/place")!
    }

    public var path: String {
        switch self {
        case .place:
            return "/nearbysearch/json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
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
        return [
            "Content-Type": "application/json"
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
