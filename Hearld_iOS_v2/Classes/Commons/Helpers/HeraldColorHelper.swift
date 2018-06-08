//
//  HeraldColorHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

class HeraldColorHelper {
    enum LabelTextColor {
        /// 标签中的文字颜色
        static let PrimaryDk = UIColor(red: 35/255, green: 122/255, blue: 134/255, alpha: 1.0)
        /// 标签中表示成功的文字颜色
        static let SuccessDk = UIColor(red: 100/255, green: 135/255, blue: 50/255, alpha: 1.0)
        /// 标签中表示警告的文字颜色
        static let WarningDk = UIColor(red: 135/255, green: 107/255, blue: 35/255, alpha: 1.0)
        /// 标签中表示错误的文字颜色
        static let ErrorDk = UIColor(red: 135/255, green: 47/255, blue: 35/255, alpha: 1.0)
    }
    
    enum NormalTextColor {
        /// 普通文字
        static let Primary = UIColor(red: 0/255, green: 171/255, blue: 195/255, alpha: 1.0)
        /// 表示成功的普通文字
        static let Success = UIColor(red: 126/255, green: 194/255, blue: 0, alpha: 1.0)
        /// 表示警告的普通文字
        static let Warning = UIColor(red: 194/255, green: 139/255, blue: 0/255, alpha: 1.0)
        /// 表示错误的普通文字
        static let Error = UIColor(red: 194/255, green: 23/255, blue: 0/255, alpha: 1.0)
    }
    
    enum HintColor {
        /// 普通提示色块
        static let PrimaryLt = UIColor(red: 112/255, green: 234/255, blue: 250/255, alpha: 1.0)
        /// 表示成功的提示色块
        static let SuccessLt = UIColor(red: 202/255, green: 250/255, blue: 112/255, alpha: 1.0)
        /// 表示警告的提示色块
        static let WarningLt = UIColor(red: 250/255, green: 211/255, blue: 112/255, alpha: 1.0)
        /// 表示错误的提示色块
        static let ErrorLt = UIColor(red: 250/255, green: 128/255, blue: 112/255, alpha: 1.0)
    }
    
    enum LabelBgColor {
        /// 普通标签背景
        static let PrimaryBg = UIColor(red: 221/255, green: 251/255, blue: 255/255, alpha: 1.0)
        /// 表示成功的标签背景
        static let SuccessBg = UIColor(red: 243/255, green: 255/255, blue: 222/255, alpha: 1.0)
        /// 表示警告的标签背景
        static let WarningBg = UIColor(red: 255/255, green: 246/255, blue: 222/255, alpha: 1.0)
        /// 表示错误的标签背景
        static let ErrorBg = UIColor(red: 255/255, green: 226/255, blue: 222/255, alpha: 1.0)
    }
    
    enum GeneralColor {
        /// Regular
        static let Regular = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        /// Bold
        static let Bold = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
        /// Secondary
        static let Secondary = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        /// Divider: 用于分割线
        static let Divider = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        /// ToolBg: 背景色
        static let ToolBg = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        /// 白色
        static let White = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
}
