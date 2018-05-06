//
//  LectureView.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 29/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SVProgressHUD

class LectureView : UIView {
    
    var staticLabel = UILabel()
    var doneLabel = UILabel()
    var remainLabel = UILabel()
    var lectureTableView = UITableView()
    
    let lectureViewModel = LectureViewModel.shared
    let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        setupSubviews()
        
        lectureTableView.delegate = self
        lectureTableView.dataSource = self
        lectureTableView.register(LectureTableViewCell.self, forCellReuseIdentifier: "lecture")
        
        // 订阅Lecture请求
        lectureViewModel.LectureList.subscribe(
            onNext: { lectureArray in
                self.doneLabel.text = "已听讲座次数 " + String(lectureArray.count)
                let remianCount = (lectureArray.count) > 8 ? 0 : (8 - lectureArray.count)
                self.remainLabel.text = "剩余讲座次数 " + String(remianCount)
                self.lectureTableView.reloadData()
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
    }
        
    private func setupSubviews() {
        staticLabel.into(self).top(20).centerX().height(35).width(100).color(HeraldColorHelper.Regular).text("人文讲座").font(18,.semibold).align(.center)
        
        doneLabel.into(self).below(staticLabel, 25).left(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(17,.semibold).align(.center)
        
        remainLabel.into(self).below(staticLabel, 25).right(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(17,.semibold).align(.center)
        
        lectureTableView.into(self).below(doneLabel, 10).left(5).right(5).bottom(5)
        lectureTableView.isScrollEnabled = false
    }
}
