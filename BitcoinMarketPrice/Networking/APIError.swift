//
//  APIError.swift
//  net
//
//  Created by Glauco Dantas Beserra on 28/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

enum APIError: Error {
    case success
    case noInternetConnection
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    
    case responseUnsuccessful
    
    var localizedDescription: String {
        switch self {
        case .success:              return "Success"
        case .noInternetConnection: return "Please check your network connection."
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .noData:               return "Response returned with no data to decode."
        
        case .authenticationError:  return "You need to be authenticated first."
        case .badRequest:           return "Bad request"
        case .outdated:             return "The url you requested is outdated."
        case .failed:               return "Network request failed."
        
        case .unableToDecode:       return "We could not decode the response."
        }
    }
}
