//
//  TextAttributesHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

class TextAttributesHelper {
    static let titleTextAttributes: [String : Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18), NSForegroundColorAttributeName: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) ]
    
    static let greyTextAttributes: [String : Any] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor ( red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0 )]
}

fileprivate let weights = [
    UIFontWeightUltraLight,
    UIFontWeightThin,
    UIFontWeightLight,
    UIFontWeightRegular,
    UIFontWeightMedium,
    UIFontWeightSemibold,
    UIFontWeightBold,
    UIFontWeightHeavy,
    UIFontWeightBlack
]

extension NSMutableAttributedString {
    func range() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    @discardableResult func font(_ size: CGFloat = 14, _ weight: FontWeight = .regular, _ range: NSRange) -> Self{
        let fontAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: size, weight: weights[weight.rawValue]) ]
        self.addAttributes(fontAttribute, range: range)
        return self
    }
    
    @discardableResult func color(_ color: UIColor, _ range: NSRange) -> Self{
        let colorAttribute = [NSForegroundColorAttributeName: color]
        self.addAttributes(colorAttribute, range: range)
        return self
    }
}
