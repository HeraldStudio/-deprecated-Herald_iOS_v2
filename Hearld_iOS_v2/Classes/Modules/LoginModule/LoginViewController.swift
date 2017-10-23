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

class LoginViewController: UIViewController {
    
    var viewModel = LoginViewModel()
    let bag = DisposeBag()
    
    //Mark - 交互性UI控件
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var loginButton = UIButton()
    var hintLabel = UILabel()
    
    //Mark - 装饰的UI控件
    var slogonLabel = UILabel()
    var logoImageView = UIImageView()
    var productTitle = UILabel()
    var productSubTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(subViews: [usernameTextField,passwordTextField,loginButton,hintLabel,
                                    slogonLabel,logoImageView,productTitle,productSubTitle])
        layoutSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func layoutSubViews(){
        //自顶向下
        slogonLabel.top(80).centerX().bottom(usernameTextField,49).width(275.5).height(21)
        
        usernameTextField.centerX().top(slogonLabel,49).bottom(passwordTextField).width(240).height(40)
        usernameTextField.placeholder = "一卡通号"
        usernameTextField.borderStyle = .none
        
        passwordTextField.centerX().top(usernameTextField).bottom(loginButton).width(240).height(40)
        passwordTextField.borderStyle = .none
        passwordTextField.placeholder = "请输入密码"
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
