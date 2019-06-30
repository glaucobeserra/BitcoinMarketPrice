//
//  EndPoint.swift
//  net
//
//  Created by Glauco Dantas Beserra on 28/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

protocol EndPoint {
    var scheme: String          { get }
    var host:   String          { get }
    var path:   String          { get }
    var method: HTTPMethod      { get }
    var header: [String:String] { get }
    var body:   [String:Any]    { get }
    var query:  [String:String] { get }
}

extension EndPoint {
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = query.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components
    }
    
    var request: URLRequest? {
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}
