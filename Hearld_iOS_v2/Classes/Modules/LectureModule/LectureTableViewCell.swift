//
//  LectureTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 19/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import UIKit

class LectureTableViewCell: UITableViewCell {
    
    var cardView = UIView()
    var timeLabel = UILabel()
    var locationLabel = UILabel()
    
    var bg_color: UIColor?
    var text_color: UIColor?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
 
    fileprivate func customInit() {
        cardView.addSubViews(subViews: [timeLabel,locationLabel])
        self.contentView.addSubViews(subViews: [cardView])
        self.selectionStyle = .none
        layoutUI()
    }
    
 
    func layoutUI() {
        // 背景
        contentView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        
        // 时间
        timeLabel.top(16).left(15).width(150).height(17).bottom(16)
            .font(15,.semibold).color(#colorLiteral(red: 0, green: 0.6705882353, blue: 0.7647058824, alpha: 1))
        
        // 地点
        locationLabel.top(16).right(15).width(150).height(17).bottom(16)
            .font(15,.semibold).color(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)).align(NSTextAlignment.right)
        
        // 卡片容器
        cardView.top().left().right().bottom(2)
            .clip(true).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
}

