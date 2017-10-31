//
//  ApiRouter.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya

struct ApiHelper{
    
    static let auth_url = "uc/auth"
    static let api_root = "api/"
    
    static let appid = "9f9ce5c3605178daadc2d85ce9f8e064"
    
    static func api(_ subPath: String) -> String{
        return ApiHelper.api_root + subPath
    }
}

enum UserAPI{
    case Login(userID: String, password: String)
    case Info()
}

extension UserAPI: TargetType{
    
    var baseURL: URL { return URL(string: "https://www.heraldstudio.com/")! }
    
    var path: String{
        switch self {
        case .Login(_,_):
            return ApiHelper.auth_url
        case .Info():
            return ApiHelper.api("user")
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .Login, .Info:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .Login, .Info:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .Login(let userID, _):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .Info():
            return "info".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .Login(let userID, let password):
            return .requestParameters(parameters: ["appid": ApiHelper.appid,"user": userID,"password": password], encoding: URLEncoding.queryString)
        case .Info():
            return .requestParameters(parameters: ["uuid": HearldUserDefault.uuid!], encoding: JSONEncoding.default)
        }
    }
    var headers: [String: String]? {
        switch self {
        case .Login(_,_):
            return ["Content-type": "application/x-www-form-urlencoded"]
        case .Info():
            return ["Content-type": "application/json"]
        }
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}
