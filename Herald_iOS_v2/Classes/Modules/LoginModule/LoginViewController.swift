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
    
    // MARK: - 交互性UI控件
    var cardIDTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var hintLabel = UILabel()
    
    // MARK - 装饰的UI控件
    var slogonLabel = UILabel()
    var logoImageView = UIImageView()
    var productTitle = UILabel()
    var productSubTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HeraldColorHelper.GeneralColor.White
        view.addSubViews(subViews: [cardIDTextField,passwordTextField,loginButton,hintLabel,
                                    slogonLabel,logoImageView,productTitle,productSubTitle])
        layoutUI()
        
        // 登录的输入是否合法的变量
        let validVariable = Variable(false)
        // username输入的观察对象
        let usernameObservable = cardIDTextField.rx.text.asObservable().map{
            (username: String?) -> Bool in
            return ValidInputHelper.isValidUserName(username: username!)
        }
        // password输入的观察对象
        let passwordObservable = passwordTextField.rx.text.asObservable().map{
            (password: String?) -> Bool in
            return ValidInputHelper.isValidPassword(password: password!)
        }
        // combineLatest操作符
        Observable.combineLatest(usernameObservable, passwordObservable){
            (isValidUsername: Bool, isValidPassword: Bool) in
                return [isValidUsername,isValidPassword]
            }.map { (input: [Bool]) -> Bool in
                return input.reduce(true, {$0 && $1})
            }.bind(to: validVariable).addDisposableTo(bag)
        
        // 订阅loginButton tap事件
        loginButton.rx.tap.asObservable().subscribe({_ in
            if validVariable.value == true{
                let requestData = LoginModel(self.cardIDTextField.text!, self.passwordTextField.text!)
                self.viewModel.model = requestData
                self.viewModel.requestLogin()
                // 改变loginButton状态
                self.loginButton.isEnabled = false
            }else{
                SVProgressHUD.showInfo(withStatus: "输入不完整，请重试")
            }
        }).addDisposableTo(bag)
        
        // view订阅viewModel的loginInfo
        viewModel.loginInfo.subscribe(
            onNext:{ text in
                let navigationVC = MainNavigationController()
                let mainTabVC = MainTabBarController()
                navigationVC.pushViewController(mainTabVC, animated: false)
                mainTabVC.setTab()
                self.present(navigationVC, animated: true, completion: nil)
            },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.loginButton.isEnabled = true
            }
        ).addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 布局函数
    private func layoutUI(){
        loginButton.centerX().centerY().width(280).height(40)
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = HeraldColorHelper.HintColor.PrimaryLt
        
        passwordTextField.centerX().above(loginButton,15).width(240).height(40)
            .placeholder("统一身份认证密码").borderStyle(.none).isSecureText(true)
        
        cardIDTextField.centerX().above(passwordTextField).width(240).height(40)
            .placeholder("一卡通号").borderStyle(.none)
        
        slogonLabel.top(95).centerX().width(275.5).height(21)
            .text("「登录小猴偷米，享受校园生活」").font(18)
        
        hintLabel.centerX().below(loginButton,20).width(257.5).height(12)
            .text("登录即代表您已阅读并同意服务协议及隐私政策").font(12).color(HeraldColorHelper.GeneralColor.Regular)
    }
}
