//
//  ErrorHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

enum HeraldError : Error {
    case NetworkError
    case UserNotExist
    
    var localizedDescription: String{
        switch self {
        case .NetworkError:
            return "网络超时"
        case .UserNotExist:
            return "用户不存在或网络异常，请重试"
        default:
            return "unknown error"
        }
    }
}
