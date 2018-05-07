//
//  GPAView.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SVProgressHUD
import Realm
import RealmSwift

class GPAView : UIView {
    
    var staticLabel = UILabel()
    var creditLabel = UILabel()
    var noMaskCreditLabel = UILabel()
    var computedTimeLabel = UILabel()
    var gpaTableView = UITableView()
    
    let gpaViewModel = GPAViewModel.shared
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
        setupSubViews()
        
        gpaTableView.delegate = self
        gpaTableView.dataSource = self
        
        gpaTableView.register(GPATableViewCell.self, forCellReuseIdentifier: "gpa")
        
        gpaViewModel.GPAList.subscribe(
            onNext: { gpaArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first!
                
                self.creditLabel.text = "绩点 " + currentUser.gpa
                self.noMaskCreditLabel.text = "首修 " + currentUser.gpaBeforeMakeup
                let calcutionTime = currentUser.gpaCalcutionTime.substring(NSRange(location: 0, length: currentUser.gpaCalcutionTime.length()-3))
                let date = TimeConvertHelper.convert(from: calcutionTime)
                let displayTime = TimeConvertHelper.convert(from: date)
                self.computedTimeLabel.text = displayTime
                self.gpaTableView.reloadData()
        },
            onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
    }
    
    private func setupSubViews() {
        staticLabel.into(self).top(20).centerX().height(35).width(100).color(HeraldColorHelper.Regular).text("成绩").font(18,.semibold).align(.center)
        
        noMaskCreditLabel.into(self).below(staticLabel,25).centerX().width(100).height(30).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        creditLabel.into(self).below(staticLabel, 25).before(noMaskCreditLabel, 3).height(30).width(100).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        computedTimeLabel.into(self).below(staticLabel, 25).after(noMaskCreditLabel, 3).height(30).width(100).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        gpaTableView.into(self).below(creditLabel, 10).left(5).right(5).bottom(5)
        gpaTableView.isScrollEnabled = false
    }
}
