//
//  BlockchainServices.swift
//  net
//
//  Created by Glauco Dantas Beserra on 30/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

enum BlockchainServices {
    case marketPrice(timespan: Timespan)
}

extension BlockchainServices: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.blockchain.info"
    }
    
    var path: String {
        return "/charts/market-price"
    }
    
    var query: [String : String] {
        switch self {
        case .marketPrice(let timespan):
            return ["timespan": timespan.rawValue]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return [:]
    }
}
