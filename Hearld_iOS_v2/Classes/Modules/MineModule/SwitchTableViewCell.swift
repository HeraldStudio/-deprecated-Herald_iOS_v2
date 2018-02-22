//
//  SwitchTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 04/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class SwitchTableViewCell: UITableViewCell {
    var remindText = ""
    var wordLabel = UILabel()
    var switchh = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubViews(subViews: [wordLabel,switchh])
        self.selectionStyle = .none
        layoutSubviews()
        
        switchh.rx.isOn.asObservable().subscribe { (isOn) in
            switch self.remindText {
            case "上课提醒":
                HearldUserDefault.defaults.set(isOn.element!, forKey: isRemindLessonKey)
                isRemindLesson.value = isOn.element!;
            case "实验提醒":
                HearldUserDefault.defaults.set(isOn.element!, forKey: isRemindExperimentKey)
                isRemindExperiment.value = isOn.element!;
            case "考试提醒":
                HearldUserDefault.defaults.set(isOn.element!, forKey: isRemindTestKey)
                isRemindTest.value = isOn.element!;
            default:
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        wordLabel.top(8).left(8).bottom(8).font(16,.regular).color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        switchh.right(10).centerY(wordLabel)
    }

}
