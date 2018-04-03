//
//  InfoTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Realm
import RealmSwift
import SVProgressHUD

class InfoTableViewCell: UITableViewCell {
    
    // Mark - UI stuff
    var staticLabel = UILabel()
    var nameLabel = UILabel()
    var identityLabel = UILabel()
    var logoutButton = UIButton()
    var cardExtraButton = UIButton()
    var peButton = UIButton()
    var lectureButton = UIButton()
    var strpButton = UIButton()
    var gradeButton = UIButton()
    
    let buttonWidth = (screenRect.width - 10) / 5
    
    var underLine_1 = UIView()
    var underLine_2 = UIView()
    
    var verticalLine_1 = UIView()
    var verticalLine_2 = UIView()
    var verticalLine_3 = UIView()
    var verticalLine_4 = UIView()

    var infoList: [infoItem] = [] { didSet { updateUI() }}
    
    // Mark : ViewModel
    var strpViewModel = SRTPViewModel()
    var lectureViewModel = LectureViewModel()
    var gpaViewModel = GPAViewModel()
    let bag = DisposeBag()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        setupSubviews()
        
        // 订阅是否登录的信息
//        isLoginVariable.asObservable().subscribe(
//            onNext:{ isLogin in
//                if isLogin {
//                    self.prepareData()
//                }else{
//                    self.user = User()
//                    self.prepareData()
//                }
//        }).addDisposableTo(bag)
        
        /// 分别订阅5个Button对应的网络请求
        subscribeButton()
    }
    
    private func subscribeButton() {
        strpViewModel.SRTPList.subscribe(
            onNext:{ strpArray in
                let desc = "STRP\n"
                let number = strpArray[0].credit
                self.dealWithButton(self.strpButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
    }
    
    private func setupSubviews() {
        // 信息板
        staticLabel.into(contentView).top(15).centerX().height(20).width(50).text("信息板").font(16,.bold)
        
        // 名字
        nameLabel.into(contentView).below(staticLabel,8).left(15).height(30).font(16,.light)
        
        // 身份
        identityLabel.into(contentView).after(nameLabel,15).below(staticLabel,18).height(15).font(13,.regular).color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        // 注销按钮
//        logoutButton.into(contentView).below(staticLabel,10).right(15)
        
        // 画线
        underLine_1.into(contentView).below(nameLabel,4).width(screenRect.width).height(1).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // 一卡通余额按钮
        cardExtraButton.into(contentView).below(underLine_1,10).left(3).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线1
        verticalLine_1.into(contentView).below(underLine_1,10).after(cardExtraButton,0).width(1).height(70).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // 跑操按钮
        peButton.into(contentView).below(underLine_1,10).after(verticalLine_1,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线2
        verticalLine_2.into(contentView).below(underLine_1,10).after(peButton,0).width(1).height(70).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // 讲座按钮
        lectureButton.into(contentView).below(underLine_1,10).after(verticalLine_2,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线3
        verticalLine_3.into(contentView).below(underLine_1,10).after(lectureButton,0).width(1).height(70).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // STRP按钮
        strpButton.into(contentView).after(verticalLine_3,0).below(underLine_1,10).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线4
        verticalLine_4.into(contentView).below(underLine_1,10).after(strpButton,0).width(1).height(70).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // 绩点按钮
        gradeButton.into(contentView).below(underLine_1,10).after(verticalLine_4,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)

        // 画线
        underLine_2.into(contentView).below(cardExtraButton,4).width(screenRect.width).height(1).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1)).bottom(1)
    }
    
    private func updateUI() {
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first
        
        // 姓名与身份
        nameLabel.text = user?.username
        identityLabel.text = user?.identity
        
        for info in infoList {
            var number: String
            var desc: String
            switch info {
            case .cardExtra:
                desc = "余额\n"
                number = "···"
                dealWithButton(cardExtraButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
            case .pe:
                desc = "跑操\n"
                number = "···"
                dealWithButton(peButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
            case .lecture():
                desc = "讲座\n"
                number = "···"
                dealWithButton(lectureButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
            case .srtp():
                desc = "STRP\n"
                number = "···"
                dealWithButton(strpButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
            case .grade():
                desc = "绩点\n"
                number = "···"
                dealWithButton(gradeButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: #colorLiteral(red: 0.004808220547, green: 0.6691957116, blue: 0.7637698054, alpha: 1), descSize: 15, descFont: .semibold, descColor: #colorLiteral(red: 0.8566188135, green: 0.8566188135, blue: 0.8566188135, alpha: 1))
            }
        }
    }
    
    fileprivate func dealWithButton(_ button: UIButton, number: String, desc: String, numSize: CGFloat, numFont: FontWeight, numColor: UIColor, descSize: CGFloat, descFont: FontWeight, descColor: UIColor) {
        let text = desc + number
        
        let textAttrString = NSMutableAttributedString.init(string: text)
        
        let descIndex = desc.length()
        let numberIndex = number.length()
        
        let descRange = NSRange(location: 0, length: descIndex)
        let numberRange = NSRange(location: descIndex, length: numberIndex)
        
        textAttrString.font(descSize, descFont, descRange).color(descColor,descRange).font(numSize, numFont, numberRange).color(numColor,numberRange)
        button.setAttributedTitle(textAttrString, for: .normal)
    }

}
