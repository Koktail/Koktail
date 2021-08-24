//
//  FavoriteCocktailViewModel.swift
//  Koktail
//
//  Created by 정연희 on 2021/08/24.
//

import RxCocoa
import SwiftyJSON
import Alamofire
import Moya

class FavoriteCocktailViewModel {
    
    struct State {
        let success = PublishRelay<FavoriteCocktailAPIResponse>()
        let fail = PublishRelay<Bool>()
    }
    
    let state = State()
    let provider = MoyaProvider<CocktailNetworkingManger>()
        
    public func request(parameters: Parameters = Parameters()) {
        CocktailNetworkingManger.parameter = parameters
        provider.request(.favoriteCocktail) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let favoriteCocktail = try?
                        FavoriteCocktailAPIResponse(JSON(rawValue: response.mapJSON())!) else {
                    self.state.fail.accept(true)
                    return
                }
                self.state.success.accept(favoriteCocktail)
            case .failure:
                self.state.fail.accept(true)
            }
        }
    }
}
