//
//  ExtUIViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 04/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SVProgressHUD

private var _progressDialogShown = false

extension UIViewController{
    
    static var progressDialogShown : Bool {
        get {
            return _progressDialogShown
        } set {
            _progressDialogShown = newValue
        }
    }
    
    /// 显示加载框（全局单例）
    static func showProgressDialog() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        SVProgressHUD.show()
        progressDialogShown = true
    }
    
    func showProgressDialog() {
        UIViewController.showProgressDialog()
    }
    
    /// 隐藏加载框（全局单例）
    static func hideProgressDialog() {
        SVProgressHUD.dismiss()
        progressDialogShown = false
    }
    
    func hideProgressDialog() {
        UIViewController.hideProgressDialog()
    }
}
