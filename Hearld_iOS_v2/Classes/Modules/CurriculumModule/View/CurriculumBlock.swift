//
//  CurriculumBlock.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 2018/6/4.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

class CurriculumBlock : UIView {
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
        self.background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        courseLabel.into(self).top(3).left(3).right(3).lines(0).font(13, FontWeight.regular).color(HeraldColorHelper.Primary)
        
        teacherLabel.into(self).below(courseLabel,3).left(0).right(0).lines(0).font(13, FontWeight.regular).color(HeraldColorHelper.Secondary)
        
        locationLabel.into(self).bottom(3).left(3).right(3).left(0).right(0).lines(0).font(13, FontWeight.regular).color(HeraldColorHelper.Bold)
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
