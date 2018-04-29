//
//  LectureTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 19/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class LectureTableViewCell: UITableViewCell {
    
    var lecture: LectureModel? { didSet { updateUI() } }
    
    var timeLabel = UILabel()
    var locationLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
 
    private func customInit() {
        self.selectionStyle = .none
        layoutUI()
    }
    
    private func layoutUI() {
        // 背景
        contentView.background(#colorLiteral(red: 0.9566619039, green: 0.9566619039, blue: 0.9566619039, alpha: 1))
        
        // 时间
        timeLabel.into(contentView).top(10).left(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(#colorLiteral(red: 0, green: 0.6705882353, blue: 0.7647058824, alpha: 1))
        
        // 地点
        locationLabel.into(contentView).top(10).right(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)).align(NSTextAlignment.right)
    }
    
    private func updateUI() {
        let date = TimeConvertHelper.convert(from: (lecture?.time)!)
        let displayTime = TimeConvertHelper.convert(from: date)
        timeLabel.text = displayTime
        locationLabel.text = lecture?.location
    }
}

