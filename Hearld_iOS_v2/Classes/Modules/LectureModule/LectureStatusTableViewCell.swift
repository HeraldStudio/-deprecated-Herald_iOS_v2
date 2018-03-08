//
//  LectureStatusTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 08/03/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//


import Foundation
import UIKit

class LectureStatusTableViewCell: UITableViewCell {
    var cardView = UIView()
    var countLabel = UILabel()
    var leftLabel = UILabel()
    
    var bg_color: UIColor?
    var text_color: UIColor?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.addSubViews(subViews: [countLabel,leftLabel])
        self.contentView.addSubViews(subViews: [cardView])
        self.selectionStyle = .none
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // 背景
        contentView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        // 卡片容器
        cardView.top().left().right().bottom(2)
            .clip(true).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        // 已听次数
        countLabel.top(30).centerX(-75).width(140).bottom(22).height(30)
            .font(16,.semibold).color(#colorLiteral(red: 0.137254902, green: 0.4784313725, blue: 0.5254901961, alpha: 1)).background(#colorLiteral(red: 0.8666666667, green: 0.9843137255, blue: 1, alpha: 1)).align(NSTextAlignment.center).round(3)
        
        // 剩余次数
        leftLabel.top(30).after(countLabel,10).width(140).height(30).bottom(22)
            .font(16,.semibold).color(#colorLiteral(red: 0.137254902, green: 0.4784313725, blue: 0.5254901961, alpha: 1)).background(#colorLiteral(red: 0.8666666667, green: 0.9843137255, blue: 1, alpha: 1)).align(NSTextAlignment.center).round(3)
        
        
    }
}


