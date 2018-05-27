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
    var text_color: UIColor? { didSet {stateLabel.color(text_color!) } }
    var detailURL: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        self.selectionStyle = .none
        layoutUI()
    }
    
    private func layoutUI() {
        // 背景
        contentView.background(HeraldColorHelper.background)
        
        // 状态
        stateLabel.into(cardView).left(10).top(10).width(50).height(20)
            .clip(true).font(12).align(.center).round(3.0)

        // 标题
        titleLabel.into(cardView).after(stateLabel,8).top(stateLabel).right(10)
            .font(16,.regular).color(HeraldColorHelper.Regular).lines(0)

        // 图片
        picture.into(cardView).below(titleLabel,12).left(10).right(10).height(125)
            .clip(true).round(5.0)

        // 介绍 用Autolayout帮我们解决动态label高度的问题
        introductionLabel.into(cardView).below(picture,10).left(10).right(10).bottom(12)
            .lines(0).font(14,.regular).color(HeraldColorHelper.Secondary).align(.natural)
        
        // 卡片容器
        cardView.into(contentView).top(5).left(8).right(8).bottom(5)
            .clip(true).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).round(5.0)
    }
}
