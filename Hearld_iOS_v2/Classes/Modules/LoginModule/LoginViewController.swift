//
//  LoginViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD

class LoginViewController: UIViewController {
    
    var viewModel = LoginViewModel()
    let bag = DisposeBag()
    
    // Mark - 交互性UI控件
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var hintLabel = UILabel()
    
    // Mark - 装饰的UI控件
    var slogonLabel = UILabel()
    var logoImageView = UIImageView()
    var productTitle = UILabel()
    var productSubTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(subViews: [usernameTextField,passwordTextField,loginButton,hintLabel,
                                    slogonLabel,logoImageView,productTitle,productSubTitle])
        layoutSubViews()
        
        //登录事件流
        let validVariable = Variable(false)
        
        let usernameObservable = usernameTextField.rx.text.asObservable().map{
            (username: String?) -> Bool in
            return ValidInputHelper.isValidUserName(username: username!)
        }
        let passwordObservable = passwordTextField.rx.text.asObservable().map{
            (password: String?) -> Bool in
            return ValidInputHelper.isValidPassword(password: password!)
        }
        
        Observable.combineLatest(usernameObservable, passwordObservable){
            (isValidUsername: Bool, isValidPassword: Bool) in
                return [isValidUsername,isValidPassword]
            }.map { (input: [Bool]) -> Bool in
                return input.reduce(true, {$0 && $1})
            }.subscribe(onNext: {
                validVariable.value = $0
            }).addDisposableTo(bag)
        
        loginButton.rx.tap.asObservable().subscribe({_ in
            if validVariable.value == true{
//                let requestData = LoginModel(self.usernameTextField.text!, self.passwordTextField.text!)
//                self.viewModel.model = requestData
//                self.viewModel.requestLogin()
                SVProgressHUD.showInfo(withStatus: "登录成功")
            }else{
                SVProgressHUD.showInfo(withStatus: "输入不完整，请重试")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func layoutSubViews(){
        loginButton.centerX().centerY().width(280).height(40)
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        passwordTextField.centerX().above(loginButton,15).width(240).height(40)
            .placeholder("统一身份认证密码").borderStyle(.none)
        
        usernameTextField.centerX().above(passwordTextField).width(240).height(40)
            .placeholder("一卡通号").borderStyle(.none)
        
        slogonLabel.top(95).centerX().width(275.5).height(21)
            .text("「登录小猴偷米，享受校园生活」").font(18)
        
        hintLabel.centerX().below(loginButton,20).width(257.5).height(12)
            .text("登录即代表您已阅读并同意服务协议及隐私政策").font(12).color(#colorLiteral(red: 0.7574584487, green: 0.7574584487, blue: 0.7574584487, alpha: 1))
    }
}
