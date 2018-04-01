//
//  InfoTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

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
    
    var underLine_1 = UIView()
    var underLine_2 = UIView()

    var infoList: [infoItem] = [] { didSet { updateUI() }}
    
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
    }
    
    private func setupSubviews() {
        // 信息板
        staticLabel.into(contentView).top(15).centerX().height(20).width(50).text("信息板").font(16,.bold)
        
        // 名字
        nameLabel.into(contentView).below(staticLabel,10).left(15).height(30).font(16,.light)
        
        // 身份
        identityLabel.into(contentView).after(nameLabel,8).below(staticLabel,15).height(15).font(13,.regular).color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        // 注销按钮
        logoutButton.into(contentView).below(staticLabel,10).right(15)
        
        // 画线
        underLine_1.into(contentView).below(logoutButton,10).width(screenRect.width).height(1).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
        
        // 一卡通余额按钮
        cardExtraButton.into(contentView).below(underLine_1,10).left(0).width(screenRect.width / 5).height(40)
        
        // 绩点按钮
        gradeButton.into(contentView).below(underLine_1,10).right(0).width(screenRect.width / 5).height(40)
        
        // 跑操按钮
        peButton.into(contentView).below(underLine_1,10).after(cardExtraButton,0).width(screenRect.width / 5).height(40)
        
        // 讲座按钮
        lectureButton.into(contentView).below(underLine_1,10).after(peButton,0).width(screenRect.width / 5).height(40)
        
        // STRP按钮
        strpButton.into(contentView).before(gradeButton,0).below(underLine_1,10).width(screenRect.width / 5).height(5)
        
        // 画线
        underLine_2.into(contentView).below(strpButton,10).width(screenRect.width).height(1).background(#colorLiteral(red: 0.9103347081, green: 0.9103347081, blue: 0.9103347081, alpha: 1))
    }
    
    private func updateUI() {
        
    }
    
    fileprivate func dealWithButton(_ button: UIButton, number: String, desc: String, numSize: CGFloat, numFont: FontWeight, numColor: UIColor, descSize: CGFloat, descFont: FontWeight, descColor: UIColor) {
        let text = number + desc
        let textAttrString = NSMutableAttributedString.init(string: text)
        
        let numberIndex = number.length()
        let descIndex = desc.length()
        
        let numberRange = NSRange(location: 0, length: numberIndex)
        let descRange = NSRange(location: numberIndex + 1, length: descIndex - 1 )
        
        textAttrString.font(numSize, numFont, numberRange).color(numColor,numberRange).font(descSize, descFont, descRange).color(descColor,descRange)
        button.setAttributedTitle(textAttrString, for: .normal)
    }

}
