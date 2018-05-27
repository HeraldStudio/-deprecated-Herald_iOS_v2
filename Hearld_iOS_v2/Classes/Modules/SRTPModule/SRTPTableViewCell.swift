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
    
    var srtp : SRTPModel? { didSet { updateUI() } }
    
    var infoLabel = UILabel()
    var projectLabel = UILabel()
    var creditLabel = UILabel()
    
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
        // 项目名称
        projectLabel.into(contentView).top(10).left(15).right(15)
            .font(17,.semibold).color(HeraldColorHelper.Primary).lines(0).breakMode(NSLineBreakMode.byCharWrapping)
        
        // 所获学分和比重
        creditLabel.into(contentView).below(projectLabel,8).left(15).width(100).height(17).bottom(10)
            .font(15,.semibold).color(HeraldColorHelper.Regular)
        
        // 项目信息
        infoLabel.into(contentView).below(projectLabel,8).right(15).width(180).height(17).bottom(10)
            .font(15,.regular).color(HeraldColorHelper.Secondary).align(NSTextAlignment.right)
    }
    
    private func updateUI() {
        projectLabel.text = srtp?.project
        let proportion = (srtp?.proportion)! * 100
        creditLabel.text = (srtp?.credit)! + "(" + String(proportion) + ")"
        infoLabel.text = (srtp?.date)! + "·" + (srtp?.type)!
    }
}
