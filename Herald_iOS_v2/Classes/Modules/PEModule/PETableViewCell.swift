//
//  PETableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class PETableViewCell: UITableViewCell {
    var pe : PEModel? { didSet { updateUI() } }
    
    var peNameLabel = UILabel()
    var peGradeLabel = UILabel()
    var peScoreLabel = UILabel()
    var peValueLabel = UILabel()
    
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
        // 项目名字
        peNameLabel.into(contentView).top(10).left(15).width(150).height(30).font(17,.semibold).color(HeraldColorHelper.NormalTextColor.Primary)
        
        // 项目评分
        peScoreLabel.into(contentView).top(10).right(15).width(100).height(30).font(16,.semibold).color(HeraldColorHelper.GeneralColor.Bold).align(.right)
        
        // 项目成绩
        peValueLabel.into(contentView).below(peNameLabel,5).left(15).bottom(5).width(100).font(14,.semibold).color(HeraldColorHelper.GeneralColor.Regular).text("0")
        
        // 项目评价
        peGradeLabel.into(contentView).below(peScoreLabel,5).right(15).bottom(5).height(30).font(15,.semibold).color(HeraldColorHelper.GeneralColor.Divider).align(.right)
        
    }
    
    private func updateUI() {
        peNameLabel.text = pe?.name
        peGradeLabel.text = pe?.grade
        peScoreLabel.text = String(stringInterpolationSegment: (pe?.score)!)
        peValueLabel.text = String(stringInterpolationSegment: (pe?.value)!)
    }
}
