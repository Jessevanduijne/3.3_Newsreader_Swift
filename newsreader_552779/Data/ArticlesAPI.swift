//
//  ArticlesAPI.swift
//  newsreader_552779
//
//  Created by Informatica Haarlem on 16-10-19.
//  Copyright © 2019 Informatica Haarlem. All rights reserved.
//

import Foundation
import Alamofire

final class ArticlesAPI {
    static var baseURL = "https://inhollandbackend.azurewebsites.net/api/"
    
    static func getArticles(nextID: Int? = nil) -> DataRequest {
        let defaults = UserDefaults.standard
        let authToken = defaults.string(forKey: "authToken")
        
        var parameters: [String: String] = [:]
        if let nextID = nextID {
            parameters["id"] = "\(nextID)"
        }
        parameters["count"] = "20"
        
        var headers: [String: String] = [:]
        if let authToken = authToken {
            headers["x-authToken"] = authToken
        }
        
        return Alamofire.request(baseURL + "Articles", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    static func register(username: String, password: String) -> DataRequest {
        var parameters: [String: String] = [:]
        
        parameters["username"] = "\(username)"
        parameters["password"] = "\(password)"
        return Alamofire.request(baseURL + "users/register", method: .post, parameters: parameters)
    }
    
    static func login(username: String, password: String) -> DataRequest {
        var parameters: [String: String] = [:]
        
        parameters["username"] = "\(username)"
        parameters["password"] = "\(password)"
        return Alamofire.request(baseURL + "users/login", method: .post, parameters: parameters, encoding: URLEncoding.default)
    }
    
    static func updateLike(articleId: Int) -> DataRequest {
        let defaults = UserDefaults.standard
        let authToken = defaults.string(forKey: "authToken")
        let headers = ["x-authtoken": authToken!]
        return Alamofire.request(baseURL + "Articles/\(articleId)/like", method: .put, encoding: URLEncoding.default, headers: headers)
    }
    
    static func deleteLike(articleId: Int) -> DataRequest {
        let defaults = UserDefaults.standard
        let authToken = defaults.string(forKey: "authToken")
        let headers = ["x-authtoken": authToken!]
        return Alamofire.request(baseURL + "Articles/\(articleId)/like", method: .delete, encoding: URLEncoding.default, headers: headers)
    }
    
    static func likedArticles() -> DataRequest {
        let defaults = UserDefaults.standard
        let authToken = defaults.string(forKey: "authToken")
        let headers = ["x-authtoken": authToken!]
        
        return Alamofire.request(baseURL + "Articles/liked", method: .get, encoding: URLEncoding.default, headers: headers)
    }
}
