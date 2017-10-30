//
//  ErrorHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case CannotGetServerResponse
    
    var localizedDescription: String{
        switch self {
        case .CannotGetServerResponse:
            return "can not connect to server"
        default:
            return "unknown error"
        }
    }
}
