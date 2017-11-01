//
//  TextAttributesHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

let titleTextAttributes: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18), NSForegroundColorAttributeName: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]

let unselectedTextAttributes: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor ( red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0 )]

let selectedTextAttributes: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.black]
