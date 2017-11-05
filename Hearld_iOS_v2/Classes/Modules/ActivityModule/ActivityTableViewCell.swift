//
//  ActivityTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 02/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class ActivityTableViewCell: UITableViewCell {
    
    var cardView = UIView()
    var titleLabel = UILabel()
    var picture = UIImageView()
    var stateLabel = UILabel()
    var introductionLabel = UILabel()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    
    var bg_color: UIColor? { didSet {stateLabel.background(bg_color!) } }
    var text_color: UIColor? {didSet{stateLabel.color(text_color!)} }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.addSubViews(subViews: [titleLabel,stateLabel,picture,introductionLabel,timeLabel,locationLabel])
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
        
        // 状态
        stateLabel.left(10).top(10).width(45).height(20)
            .clip(true).font(12).align(.center).round(3.0)

        // 标题
        titleLabel.after(stateLabel,8).top(stateLabel).right(10)
            .font(16,.semibold).color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).lines(0)

        // 图片
        picture.below(titleLabel,12).left(10).right(10).height(125)
            .clip(true).round(5.0)

        // 介绍 用Autolayout帮我们解决动态label高度的问题
        introductionLabel.below(picture,10).left(10).right(10)
            .lines(0).font(15,.semibold).color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)).align(.natural)

        // 时间
        timeLabel.below(introductionLabel,12).left(10).right(10).height(16)
            .font(15,.semibold).color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))

        // 地点
        locationLabel.below(timeLabel,5).left(10).right(10).height(16).bottom(12)
            .font(14,.semibold).color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        // 卡片容器
        cardView.top(5).left(8).right(8).bottom(5)
            .clip(true).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).round(5.0)
    }
}
