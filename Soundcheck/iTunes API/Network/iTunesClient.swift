//
//  iTunesClient.swift
//  Soundcheck
//
//  Created by Andrew Lection on 3/31/19.
//  Copyright © 2019 Andrew Lection. All rights reserved.
//

import Foundation

final public class iTunesClient {
    
    // MARK: - Types
    public typealias QueryDictionary = [String : String]?
    typealias SuccessHandler = (_ json: Data) -> ()
    typealias FailureHandler = (_ error: Error) -> ()
    
    // MARK: - Properties
    private lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession.init(configuration: config)
    }()
    
    // MARK: - Public
    public func request<T: Decodable>(_ path: String,
                                       method: HTTPMethod,
                                       params: QueryDictionary = nil,
                                       completion: @escaping (Result<[T]>) -> ()) {
         // Perform request
        dataTask(path, method: method, params: params,
          successHandler: { data in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(iTunesResponse<T>.self, from: data)
                if let results = response.results {
                    completion(.success(results))
                } else {
                    completion(.failure(NSError()))
                }
            } catch {
                print("couldn't decode for url: " + path + params.debugDescription)
            }
        }, failureHandler: { error in
            completion(.failure(error))
        })
    }
    
    // MARK: Private
    private func dataTask(_ path: String, method: HTTPMethod, params: QueryDictionary,
        successHandler: @escaping SuccessHandler,
        failureHandler: @escaping FailureHandler) {
        
        // Construct URL
        guard let url = url(for: path, params: params) else { return }

        // Construct request
        let aRequest = request(for: url, method: method.rawValue)
        
        // Perform request
        defaultSession.dataTask(with: aRequest) { data, response, error in
            if let error = error {
                failureHandler(error)
            } else if let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 {
                successHandler(data)
            }
        }.resume()
    }
    
    // Construct URL from path and parameters
    private func url(for path: String, params: QueryDictionary) -> URL? {
        var urlComponents = URLComponents(string: iTunesConstants.baseUrl + path)
        if let params = params {
            urlComponents?.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        }
        return urlComponents?.url
    }
    
    // Construct URLRequest
    private func request(for url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}

