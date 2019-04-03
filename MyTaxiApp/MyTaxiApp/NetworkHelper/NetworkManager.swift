//
//  NetworkManager.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import Foundation


enum MTHTTPMethod {
    case post
    case get
    case put
    case delete
}

enum Result<U, T> {
    case success(U)
    case failure(T)
}
public typealias MTParams = [String: Any]
typealias MTHeader = [String: String]

class NetworkManager {
    
    private var defaultSession: URLSession?
    private var reachability: Reachability?
    
    
    required init() {
        defaultSession =  URLSession(configuration: .default)
        reachability = Reachability()
    }
    
  
    
    // MARK: - HTTP Methods
    
    func performNetworkOperation(method: MTHTTPMethod, urlString: String, params: MTParams?, header: MTHeader?, completion: @escaping (Result<Data, MTError>) -> Void) {
        
        if reachability?.connection == Reachability.Connection.none {
            let result = self.getResultError(code: 202, message: AppConstants.Error.kNoNetwork)
            completion(result)
            return
        }
        
        guard let url = self.getURLFromString(method: method, urlString: urlString, params: params) else {
            let result = self.getResultError(code: 208, message: AppConstants.Error.kInvalidUrl)
            completion(result)
            return
        }
        
        guard let request = self.getUrlRequest(method: method, url: url, params: params, header: header) else {
            let result = self.getResultError(code: 205, message: AppConstants.Error.kJsonHeader)
            completion(result)
            return
        }
        
        self.executeDataTask(request: request) { (response) in
            completion(response)
        }
    }
    
    private func getResultError(code: Int, message: String) -> Result<Data, MTError> {
        let apiError = MTError(code: code, errorType: .parsingError, description: message)
        let result =  Result<Data, MTError>.failure(apiError)
        return result
    }
    
    private func getURLFromString(method: MTHTTPMethod, urlString: String, params: MTParams?) -> URL? {
        var url: URL?
        switch method {
        case .get:
            var encodedUrl = urlString
            if params != nil {
                do {
                    var items = [URLQueryItem]()
                    var nURL = URLComponents(string:urlString)
                    for (key,value) in params! {
                        items.append(URLQueryItem(name: key, value: value as! String))
                    }
                    nURL?.queryItems = items
                    encodedUrl = (nURL?.url?.absoluteString)!
                } catch {
                    return nil
                }
            }
            url = URL(string: encodedUrl)
            
        default:
            url = URL(string: urlString)
        }
        
        return url
    }
    
    private func getUrlRequest(method: MTHTTPMethod, url: URL, params: MTParams?, header: MTHeader?) -> URLRequest? {
        var urlRequest: URLRequest?
        switch method {
        case .post:
            urlRequest = headerRequestForPost(url: url, params: params, header: header)
        case .get:
            urlRequest = generateUrlRequest(url: url, httpMethod: AppConstants.Query.kGet, header: header)
        case .put:
            urlRequest = generateUrlRequest(url: url, httpMethod: AppConstants.Query.kPut, header: header)
        case .delete:
            urlRequest = generateUrlRequest(url: url, httpMethod: AppConstants.Query.kDelete, header: header)
        }
        return urlRequest
    }
    
    // MARK: - Helper Methods
    
    private func executeDataTask(request: URLRequest, completion: @escaping (Result<Data, MTError>) -> Void) {
        var dataTask: URLSessionDataTask?
        
        dataTask = defaultSession?.dataTask(with: request) { data, response, error in
            defer { dataTask = nil }
            
            if error != nil {
                let apiError = MTError(code: (error! as NSError).code, errorType: .networkError, description: error.debugDescription)
                let result =  Result<Data, MTError>.failure(apiError)
                completion(result)
            } else {
                let result =  Result<Data, MTError>.success(data!)
                completion(result)
            }
        }
        dataTask?.resume()
    }
    
    private func headerRequestForPost(url: URL, params: MTParams?, header: MTHeader?) -> URLRequest? {
        var request = self.generateUrlRequest(url: url, httpMethod: AppConstants.Query.kPost, header: header)
        
        if params != nil {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params!, options: [])
                request.httpBody = jsonData
            } catch {
                return nil
            }
        }
        return request
    }
    
    private func generateUrlRequest(url: URL, httpMethod: String, header: MTHeader?) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 200)
        
        if header != nil {
            for key in (header?.keys)! {
                request.addValue(header![key]!, forHTTPHeaderField: key)
            }
        } else {
            //request.addValue(NCConfigUtils.sharedInstance.applicationKey!, forHTTPHeaderField: AppConstants.Query.kApplicationApiKey)
            //request.addValue(AppConstants.Query.kContentTypeJson, forHTTPHeaderField: AppConstants.Query.kContentType)
        }
        
        request.httpMethod = httpMethod
        return request
    }
}

