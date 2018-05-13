//
//  TopUpView.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 12/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class TopUpView: UIView {
    // Mark - UI stuff
    var staticLabel = UILabel()
    var textView = UITextView()
    var fiftyButton = UIButton()
    var hundredButton = UIButton()
    var twoHundredButton = UIButton()
    var threeHundredButton = UIButton()
    var fiveHundredButton = UIButton()
    var displayTextField = UITextField()
    var passwordTextField = UITextField()
    var confirmButton = UIButton()
    
    var containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        // 静态标题
        staticLabel.into(self).top(20).centerX().height(35).width(140).color(HeraldColorHelper.Regular).text("一卡通充值").font(18,.semibold).align(.center)
        
        // 文字
        textView.into(self).below(staticLabel,25).left(30).right(30).text("一卡通在线预充值并非实时到账，在校多数食堂超市网点刷卡时均可到账；极少数情况不能到账时，你也可以手动在圈存机存入任意金额；本功能仅在银行卡与学校一卡通中心之间产生交易，与小猴偷米无关")
        
        // 容器视图
        containerView.into(self).below(textView,20).left(30).right(30).height(50)
        
        let width : CGFloat = (screenRect.width - 72) / 5
        var textAttrString = NSMutableAttributedString.init(string: "50")
        var tapAttrString = NSMutableAttributedString.init(string: "50")
        textAttrString.font(16, FontWeight.semibold, NSMakeRange(0, 2))
        tapAttrString.color(HeraldColorHelper.PrimaryDk, NSMakeRange(0, 2))
        
        // 50按钮
        fiftyButton.into(containerView).top(0).bottom(0).left(0).width(width)
        fiftyButton.setAttributedTitle(textAttrString, for: .normal)
        fiftyButton.setAttributedTitle(tapAttrString, for: .selected)
        
        // 100按钮
        hundredButton.into(containerView).top(0).bottom(0).after(fiftyButton, 2).width(width)
        hundredButton.setAttributedTitle(textAttrString, for: .normal)
        hundredButton.setAttributedTitle(tapAttrString, for: .selected)
        
        // 200按钮
        twoHundredButton.into(containerView).top(0).bottom(0).after(hundredButton, 2).width(width)
        twoHundredButton.setAttributedTitle(textAttrString, for: .normal)
        twoHundredButton.setAttributedTitle(tapAttrString, for: .selected)
        
        // 300按钮
        threeHundredButton.into(containerView).top(0).bottom(0).after(twoHundredButton, 2).width(width)
        threeHundredButton.setAttributedTitle(textAttrString, for: .normal)
        threeHundredButton.setAttributedTitle(tapAttrString, for: .selected)
        
        // 500按钮
        fiveHundredButton.into(containerView).top(0).bottom(0).after(threeHundredButton, 2).width(width)
        fiveHundredButton.setAttributedTitle(textAttrString, for: .normal)
        fiveHundredButton.setAttributedTitle(tapAttrString, for: .selected)
        
        // 选择数值展示框
        displayTextField.into(self).below(containerView,25).width(200).centerX().text("50")
        
        // 密码输入框
        passwordTextField.into(self).below(containerView,8).width(200).centerX()
        
        // 确认按钮
        confirmButton.into(self).below(passwordTextField,8).width(120).centerX().background(HeraldColorHelper.PrimaryBg)
        textAttrString = NSMutableAttributedString.init(string: "确认充值")
        textAttrString.font(16, FontWeight.semibold, NSMakeRange(0, 4))
        confirmButton.setAttributedTitle(textAttrString, for: .normal)
    }
}
