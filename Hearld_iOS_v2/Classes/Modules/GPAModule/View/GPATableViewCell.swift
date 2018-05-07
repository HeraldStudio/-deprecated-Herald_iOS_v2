//
//  GPAStatusTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 26/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

class GPATableViewCell: UITableViewCell {
    
    var gpa : GPAModel? { didSet { updateUI() } }
    
    var lessonLabel = UILabel()
    var gradeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        layoutUI()
        self.selectionStyle = .none
    }
    
    private func layoutUI() {
        // 课程名称
        lessonLabel.into(contentView).top(10).left(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(HeraldColorHelper.Primary)
        
        // 成绩与学分
        gradeLabel.into(contentView).top(10).right(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(HeraldColorHelper.Regular).align(NSTextAlignment.right)
    }
    
    private func updateUI() {
        lessonLabel.text = gpa?.courseName
        gradeLabel.text = (gpa?.score)! + " (" + (gpa?.credit)! + "学分)"
    }
}

