//
//  BlockchainClient.swift
//  net
//
//  Created by Glauco Dantas Beserra on 29/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

import Foundation

class BlockchainClient: APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getMarketPrice(at timespan: Timespan, completion: @escaping (Result<MarketPrice?, APIError>) -> Void) {
        let endpoint = BlockchainServices.marketPrice(timespan: timespan)
        let request = endpoint.request
        
        fetch(with: request, decode: { json -> MarketPrice? in
            guard let marketPriceHistory = json as? MarketPrice else { return  nil }
            return marketPriceHistory
        }, completion: completion)
    }
}
