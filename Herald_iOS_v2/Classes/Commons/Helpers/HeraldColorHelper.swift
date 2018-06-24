//
//  HeraldColorHelper.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

func RGBCOLOR(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

class HeraldColorHelper {
    enum LabelTextColor {
        /// 标签中的文字颜色
        static let PrimaryDk = RGBCOLOR(r: 35, g: 122, b: 134)
        /// 标签中表示成功的文字颜色
        static let SuccessDk = RGBCOLOR(r: 100, g: 135, b: 50)
        /// 标签中表示警告的文字颜色
        static let WarningDk = RGBCOLOR(r: 135, g: 107, b: 35)
        /// 标签中表示错误的文字颜色
        static let ErrorDk = RGBCOLOR(r: 135, g: 47, b: 35)
    }
    
    enum NormalTextColor {
        /// 普通文字
        static let Primary = RGBCOLOR(r: 0, g: 175, b: 195)
        /// 表示成功的普通文字
        static let Success = RGBCOLOR(r: 126, g: 194, b: 0)
        /// 表示警告的普通文字
        static let Warning = RGBCOLOR(r: 194, g: 139, b: 0)
        /// 表示错误的普通文字
        static let Error = RGBCOLOR(r: 194, g: 23, b: 0)
    }
    
    enum HintColor {
        /// 普通提示色块
        static let PrimaryLt = RGBCOLOR(r: 112, g: 234, b: 250)
        /// 表示成功的提示色块
        static let SuccessLt = RGBCOLOR(r: 202, g: 250, b: 112)
        /// 表示警告的提示色块
        static let WarningLt = RGBCOLOR(r: 250, g: 211, b: 112)
        /// 表示错误的提示色块
        static let ErrorLt = RGBCOLOR(r: 250, g: 128, b: 112)
    }
    
    enum LabelBgColor {
        /// 普通标签背景
        static let PrimaryBg = RGBCOLOR(r: 221, g: 251, b: 255)
        /// 表示成功的标签背景
        static let SuccessBg = RGBCOLOR(r: 243, g: 255, b: 222)
        /// 表示警告的标签背景
        static let WarningBg = RGBCOLOR(r: 255, g: 246, b: 222)
        /// 表示错误的标签背景
        static let ErrorBg = RGBCOLOR(r: 255, g: 226, b: 222)
    }
    
    enum GeneralColor {
        /// Regular
        static let Regular = RGBCOLOR(r: 51, g: 51, b: 51)
        /// Bold
        static let Bold = RGBCOLOR(r: 85, g: 85, b: 85)
        /// Secondary
        static let Secondary = RGBCOLOR(r: 136, g: 136, b: 136)
        /// Divider: 用于分割线
        static let Divider = RGBCOLOR(r: 240, g: 240, b: 240)
        /// ToolBg: 背景色
        static let ToolBg = RGBCOLOR(r: 250, g: 250, b: 250)
        /// 白色
        static let White = RGBCOLOR(r: 255, g: 255, b: 255)
    }
}
