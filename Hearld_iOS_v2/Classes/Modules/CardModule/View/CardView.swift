//
//  CardView.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 10/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import Realm
import RealmSwift

class CardView: UIView {
    
    var staticLabel = UILabel()
    var balanceLabel = UILabel()
    var comsumeTimesLabel = UILabel()
    var topUpButton = UIButton()
    var cardTableView = UITableView()
    var totalCostlabel = UILabel()
    var loadButton = UIButton()
    
    var containerView_1 = UIView()
    var containerView_2 = UIView()
    
    let cardViewModel = CardViewModel.shared
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
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "Card")
        
        // 订阅Card请求
        cardViewModel.cardList.subscribe(
            onNext: { cardArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first!
                self.balanceLabel.text = "卡余额 " + String(currentUser.balance)
                self.comsumeTimesLabel.text = "今日消费次数 " + String(cardArray.count)
                var totalCost = cardArray.reduce(0, { temp, card in
                    return temp + card.amount
                })
                self.totalCostlabel.text = "今天至今 总支出 " + String(totalCost)
                self.cardTableView.reloadData()
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
    }
    
    private func setupSubviews() {
        staticLabel.into(self).top(20).centerX().height(35).width(100).color(HeraldColorHelper.Regular).text("一卡通").font(18,.semibold).align(.center)
        // 容器View
        containerView_1.into(self).below(staticLabel,25).left(40).right(40).height(30)
        
        // 余额
        balanceLabel.into(containerView_1).top(0).bottom(0).left(0).width(110).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        // 充值
        topUpButton.into(containerView_1).top(0).bottom(0).right(0).width(45).background(HeraldColorHelper.PrimaryBg)
        let textAttrString = NSMutableAttributedString.init(string: "充值")
        textAttrString.font(16, FontWeight.semibold, NSMakeRange(0, 2))
        topUpButton.setAttributedTitle(textAttrString, for: .normal)
        
        // 消费次数
        comsumeTimesLabel.into(containerView_1).top(0).bottom(0).after(balanceLabel, 5).before(topUpButton,5).background(HeraldColorHelper.PrimaryBg).font(16,.semibold).align(.center)
        
        // TableView
        cardTableView.into(self).below(containerView_1, 10).left(5).right(5)
        cardTableView.isScrollEnabled = false
        
        // 容器View
        containerView_2.into(self).below(cardTableView,10).left(50).right(50).height(30).bottom(0)
        
        // 总支出
        totalCostlabel.into(containerView_2).top(0).left(0).bottom(0).width(200).background(UIColor.white).font(15,.semibold).align(.center).color(HeraldColorHelper.Secondary)
        
        // 加载前一天
        loadButton.into(containerView_2).top(0).after(totalCostlabel, 5).right(0).bottom(0).width(90).background(HeraldColorHelper.PrimaryBg)
        let yet_textAttrString = NSMutableAttributedString.init(string: "加载前一天")
        yet_textAttrString.font(15, FontWeight.semibold, NSMakeRange(0, 5))
        loadButton.setAttributedTitle(yet_textAttrString, for: .normal)
    }
}
