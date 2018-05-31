//
//  TopUpViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TopUpViewController: UIViewController {
    
    /* UI stuff */
    var textView = UILabel()
    var fiftyButton = UIButton()
    var hundredButton = UIButton()
    var twoHundredButton = UIButton()
    var threeHundredButton = UIButton()
    var fiveHundredButton = UIButton()
    var displayLabel = UILabel()
    var passwordTextField = UITextField()
    var confirmButton = UIButton()
    
    var containerView = UIView()
    
    let bag = DisposeBag()
    
    var buttonArray : [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "一卡通充值"
        
        layoutUI()
        
        buttonArray.append(fiftyButton)
        buttonArray.append(hundredButton)
        buttonArray.append(twoHundredButton)
        buttonArray.append(threeHundredButton)
        buttonArray.append(fiveHundredButton)
        
        disableButton(fiftyButton)
        buttonArray.forEach { subscribeTap(fromButton: $0) }
        
    }
    
    private func subscribeTap(fromButton button: UIButton) {
        button.rx.tap.asObservable().subscribe({ _ in
            self.disableButton(button)
            self.displayLabel.text = button.currentAttributedTitle?.string
            for but in self.buttonArray where but != button {
                self.enableButton(but)
            }
        }).addDisposableTo(bag)
    }

    private func layoutUI() {
        view.backgroundColor = UIColor.white
        if let navigationController = self.navigationController as? MainNavigationController {
            // 文字
            textView.into(view).top(navigationController.getHeight() + 50).left(30).right(30).height(130).text("一卡通在线预充值并非实时到账，在校多数食堂超市网点刷卡时均可到账；极少数情况不能到账时，你也可以手动在圈存机存入任意金额；本功能仅在银行卡与学校一卡通中\n      心之间产生交易，与小猴偷米无关").color(HeraldColorHelper.Secondary).lines(0).font(16, .semibold)
            
            // 容器视图
            containerView.into(view).below(textView,1).left(30).right(30).height(50).width(screenRect.width - 60).centerX()
            
            let width : CGFloat = (screenRect.width - 52) / 5
            let range_two = NSMakeRange(0, 2)
            let range_three = NSMakeRange(0, 3)
            
            // 200 Button
            var textAttrString = NSMutableAttributedString.init(string: "200")
            var tapAttrString = NSMutableAttributedString.init(string: "200")
            textAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.Regular, range_three)
            tapAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.PrimaryLt, range_three)
            twoHundredButton.into(containerView).top(0).bottom(0).width(width).height(50).centerX().border(1.0, HeraldColorHelper.line).clip(true).round(1.0)
            twoHundredButton.setAttributedTitle(textAttrString, for: .normal)
            twoHundredButton.setAttributedTitle(tapAttrString, for: .selected)
            
            // 100 Button
            textAttrString = NSMutableAttributedString.init(string: "100")
            tapAttrString = NSMutableAttributedString.init(string: "100")
            textAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.Regular, range_three)
            tapAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.PrimaryLt, range_three)
            hundredButton.into(containerView).top(0).bottom(0).before(twoHundredButton, 2).width(width).height(50).border(1.0, HeraldColorHelper.line).clip(true).round(1.0)
            hundredButton.setAttributedTitle(textAttrString, for: .normal)
            hundredButton.setAttributedTitle(tapAttrString, for: .selected)
            
            // 50 Button
            textAttrString = NSMutableAttributedString.init(string: "50")
            tapAttrString = NSMutableAttributedString.init(string: "50")
            textAttrString.font(15, FontWeight.semibold, range_two).color(HeraldColorHelper.Regular, range_two)
            tapAttrString.font(15, FontWeight.semibold, range_two).color(HeraldColorHelper.PrimaryLt, range_two)
            fiftyButton.into(containerView).top(0).bottom(0).before(hundredButton,2).width(width).height(50).border(1.0, HeraldColorHelper.line).clip(true).round(1.0)
            fiftyButton.setAttributedTitle(textAttrString, for: .normal)
            fiftyButton.setAttributedTitle(tapAttrString, for: .disabled)
            
            // 300 Button
            textAttrString = NSMutableAttributedString.init(string: "300")
            tapAttrString = NSMutableAttributedString.init(string: "300")
            textAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.Regular, range_three)
            tapAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.PrimaryLt, range_three)
            threeHundredButton.into(containerView).top(0).bottom(0).after(twoHundredButton, 2).width(width).height(50).border(1.0, HeraldColorHelper.line).clip(true).round(1.0)
            threeHundredButton.setAttributedTitle(textAttrString, for: .normal)
            threeHundredButton.setAttributedTitle(tapAttrString, for: .selected)
            
            // 500 Button
            textAttrString = NSMutableAttributedString.init(string: "500")
            tapAttrString = NSMutableAttributedString.init(string: "500")
            textAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.Regular, range_three)
            tapAttrString.font(15, FontWeight.semibold, range_three).color(HeraldColorHelper.PrimaryLt, range_three)
            fiveHundredButton.into(containerView).top(0).bottom(0).after(threeHundredButton, 2).width(width).height(50).border(1.0, HeraldColorHelper.line).clip(true).round(1.0)
            fiveHundredButton.setAttributedTitle(textAttrString, for: .normal)
            fiveHundredButton.setAttributedTitle(tapAttrString, for: .selected)
            
            // 选择数值展示框
            displayLabel.into(view).below(containerView,25).width(200).centerX().text("50").align(.center).background(HeraldColorHelper.background)
            
            // 密码输入框
            passwordTextField.into(view).below(displayLabel,8).width(120).centerX().background(HeraldColorHelper.background).align(.center)
            textAttrString = NSMutableAttributedString.init(string: "六位查询密码")
            textAttrString.font(14, FontWeight.semibold, NSMakeRange(0, 6))
            passwordTextField.attributedPlaceholder = textAttrString
            passwordTextField.align(.center)
            
            // 确认按钮
            confirmButton.into(view).below(passwordTextField,8).width(80).centerX().background(HeraldColorHelper.PrimaryBg)
            textAttrString = NSMutableAttributedString.init(string: "确认充值")
            textAttrString.font(14, FontWeight.semibold, NSMakeRange(0, 4))
            confirmButton.setAttributedTitle(textAttrString, for: .normal)
        }
    }

    fileprivate func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.layer.borderColor = HeraldColorHelper.PrimaryLt.cgColor
    }
    
    fileprivate func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.layer.borderColor = HeraldColorHelper.line.cgColor
    }
}
