//
//  SearchPlaceViewModel.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/19.
//

import RxCocoa
import SwiftyJSON
import Alamofire
import Moya

class SearchPlaceViewModel {
    
    struct State {
        let success = PublishRelay<SearchPlace>()
        let fail = PublishRelay<Bool>()
    }
    
    let state = State()
    let provider = MoyaProvider<NetworkingManager>()
        
    public func request(parameters: Parameters) {
        NetworkingManager.parameter = parameters
        provider.request(.place) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let placeData = try? SearchPlace(JSON(rawValue: response.mapJSON())!) else {
                    self.state.fail.accept(true)
                    return
                }
                self.state.success.accept(placeData)
            case .failure:
                self.state.fail.accept(true)
            }
        }
    }
}
