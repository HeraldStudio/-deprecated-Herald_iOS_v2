//
//  ExtString.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

extension String{
    func substring(_ range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return self[startIndex..<endIndex]
    }
    
    func substring(_ range: NSRange) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.location)
        let endIndex = index(self.startIndex, offsetBy: range.length)
        return self[startIndex..<endIndex]
    }
    
    func length() -> Int{
        return (self as NSString).length
    }
    
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
