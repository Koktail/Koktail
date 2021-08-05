//
//  PlaceDetailViewModel.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/25.
//

import RxCocoa
import SwiftyJSON
import Alamofire
import Moya

class PlaceDetailViewModel {
    
    struct State {
        let success = PublishRelay<PlaceDetail>()
        let fail = PublishRelay<Bool>()
    }
    
    let state = State()
    let provider = MoyaProvider<NetworkingManager>()
        
    public func request(parameters: Parameters) {
        NetworkingManager.parameter = parameters
        provider.request(.placeDetail) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let placeDetail = try? PlaceDetail(JSON(rawValue: response.mapJSON())!) else {
                    self.state.fail.accept(true)
                    return
                }
                self.state.success.accept(placeDetail)
            case .failure:
                self.state.fail.accept(true)
            }
        }
    }
}
