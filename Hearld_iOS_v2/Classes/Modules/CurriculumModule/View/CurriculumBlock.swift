//
//  CurriculumBlock.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 2018/6/4.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

class CurriculumBlock: UIView {
    private let courseLabel = UILabel()
    private let teacherLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        self.background(HeraldColorHelper.GeneralColor.White)
        
        courseLabel.into(self).top(0).left(0).right(0).lines(0).font(13, FontWeight.regular).color(HeraldColorHelper.NormalTextColor.Primary).align(.center)
        
        teacherLabel.into(self).below(courseLabel,1).left(3).right(3).lines(0).font(12, FontWeight.regular).color(HeraldColorHelper.GeneralColor.Secondary).align(.center)
        
        locationLabel.into(self).bottom(0).left(0).right(0).lines(0).font(12, FontWeight.regular).color(HeraldColorHelper.GeneralColor.Bold).align(.center)
    }
    
    func setText(course: String, teacherName: String, location: String) {
        if course != "" {
            courseLabel.text = course
        }
        if teacherName != "" {
            teacherLabel.text = teacherName
        }
        if location != "" {
            locationLabel.text = location
        }
    }
}
