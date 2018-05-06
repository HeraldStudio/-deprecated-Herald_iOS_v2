//
//  SRTPView.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 05/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import Realm
import RealmSwift

class SRTPView: UIView {
    
    var staticLabel = UILabel()
    var creditLabel = UILabel()
    var statusLabel = UILabel()
    var srtpTableView = UITableView()
    
    let srtpViewModel = SRTPViewModel.shared
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
        
        srtpTableView.delegate = self
        srtpTableView.dataSource = self
        srtpTableView.register(SRTPTableViewCell.self, forCellReuseIdentifier: "SRTP")
        
        srtpViewModel.SRTPList.subscribe (
            onNext: { srtpArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first!
                
                self.creditLabel.text = "SRTP学分 " + currentUser.points
                self.statusLabel.text = "SRTP状态 " + currentUser.grade
                self.srtpTableView.reloadData()
        },
            onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
    }
    
    private func setupSubViews() {
        staticLabel.into(self).top(20).centerX().height(35).width(100).color(HeraldColorHelper.Regular).text("SRTP").font(18,.semibold).align(.center)
        
        creditLabel.into(self).below(staticLabel, 25).left(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        statusLabel.into(self).below(staticLabel, 25).right(50).height(30).width(130).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        srtpTableView.into(self).below(creditLabel, 10).left(5).right(5).bottom(5)
        srtpTableView.isScrollEnabled = false
    }
}
