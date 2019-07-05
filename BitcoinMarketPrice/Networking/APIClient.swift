//
//  APIClient.swift
//  net
//
//  Created by Glauco Dantas Beserra on 28/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

protocol APIClient {
    
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest?, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    
}

extension APIClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(nil, .noInternetConnection)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .responseUnsuccessful)
                return
            }
            
            let result = self.handleNetworkResponse(httpResponse)
            switch result {
            case .success:
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print(jsonData as Any)
                        completion(nil, .unableToDecode)
                    }
                } else {
                    completion(nil, .noData)
                }
            default:
                completion(nil, .failed)
            }
        }
        return task
    
    }
    
    func fetch<T: Decodable>(with request: URLRequest?, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let request = request else {
            completion(.failure(.badRequest))
            return
        }
        
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.unableToDecode))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.failed))
                }
            }
        }
        task.resume()
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> APIError {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .authenticationError
        case 501...599: return .badRequest
        case 600: return .outdated
        default: return .failed
        }
    }
}
