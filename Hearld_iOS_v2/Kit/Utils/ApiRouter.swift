//
//  ApiRouter.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya

enum UserAPI{
    case Login(userID: String, password: String)
    case Info(userID: String)
    case SubscribeMovement(userID: String)
}

extension UserAPI: TargetType{
    var baseURL: URL { return URL(string: "https://www.heraldstudio.com/")! }
    
    var path: String{
        switch self {
        case .Login(_,_):
            return ApiHelper.auth_url
        case .Info(let userID):
            return "users/" + userID
        case .SubscribeMovement(_):
            return "movements/all/"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .Info, .SubscribeMovement:
            return .get
        case .Login:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .Info, .Login:
            return URLEncoding.default
        case .SubscribeMovement:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .Info(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .SubscribeMovement(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .Login(let userID, _):
            return "{\"UserID\": \(userID)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .Info:
            return .requestPlain
        case .SubscribeMovement(let userID):
            return .requestParameters(parameters: ["id" : userID], encoding: URLEncoding.queryString)
        case .Login(let userID, let password):
            return .requestParameters(parameters: ["appid": ApiHelper.appid,"user": userID,"password": password], encoding: URLEncoding.default)
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}
