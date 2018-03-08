//
//  SRTPTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 26/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import UIKit

class SRTPTableViewCell: UITableViewCell {
    
    var cardView = UIView()
    var infoLabel = UILabel()
    var projectLabel = UILabel()
    var creditLabel = UILabel()
    
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
        cardView.addSubViews(subViews: [projectLabel,infoLabel,creditLabel])
        self.contentView.addSubViews(subViews: [cardView])
        self.selectionStyle = .none
        layoutUI()
    }
    
    
    func layoutUI() {
        // 背景
        contentView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        // 卡片容器
        cardView.top().left().right().bottom(2)
            .clip(true).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        // 项目名称
        projectLabel.top(18).left(20).right(14)
            .font(17,.semibold).color(#colorLiteral(red: 0, green: 0.6705882353, blue: 0.7647058824, alpha: 1)).lines(0).breakMode(NSLineBreakMode.byCharWrapping)
        
        // 所获学分和比重
        creditLabel.below(projectLabel,8).left(20).width(100).height(17).bottom(18)
            .font(16,.semibold).color(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1))
        
      
        // 项目信息
        infoLabel.below(projectLabel,8).right(22).width(180).height(17).bottom(18)
            .font(16,.semibold).color(#colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)).align(NSTextAlignment.right)
        
    
        
    }
}
