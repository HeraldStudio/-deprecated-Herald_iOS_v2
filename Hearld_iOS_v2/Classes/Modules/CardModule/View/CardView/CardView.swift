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
    
    // MARK - 实现上弹窗口
    var emptyView = UIView(frame: screenRect)
    var topUpView = TopUpView()
    
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
                let totalCost = cardArray.reduce(0, { temp, card in
                    return temp + card.amount
                })
                self.totalCostlabel.text = "今天至今 总支出 " + String(totalCost)
                self.cardTableView.reloadData()
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        initialEmptyView()
        
        topUpButton.addTarget(self, action: #selector(popView), for: .touchDown)
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
    
    private func initialEmptyView() {
        // tap撤回上弹窗口的手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDropDownView(_:)))
        // 手势需要遵循的代理：UIGestureRecognizerDelegate
        tapGestureRecognizer.delegate = self
        
        // 滑动撤回上弹窗口的手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(tapGestureRecognizer)
        emptyView.addGestureRecognizer(swipeLeft)
        emptyView.addGestureRecognizer(swipeRight)
        emptyView.addGestureRecognizer(swipeDown)
        emptyView.addGestureRecognizer(swipeUp)
    }
    
    // tap手势popOff上弹窗口
    @objc private func dismissDropDownView(_ sender: UITapGestureRecognizer) {
        popOffView()
    }
    
    // 滑动手势popOff上弹窗口
    @objc func swipe(gesture: UISwipeGestureRecognizer) {
        popOffView()
    }
    
    @objc private func popView() {
        topUpView.backgroundColor = UIColor.white
        topUpView.frame = CGRect(x: 0, y: screenRect.height, width: screenRect.width, height: 300)
        UIView.animate(withDuration: 0.3) {
            self.topUpView.frame.origin = CGPoint(x: 0, y: screenRect.height - 700)
        }
        emptyView.addSubview(topUpView)
        self.addSubview(emptyView)
    }
    
    private func popOffView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topUpView.frame.origin = CGPoint(x: 0, y: screenRect.height)
        }) { finished in
            self.topUpView.removeFromSuperview()
            self.emptyView.removeFromSuperview()
        }
    }
}

extension CardView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: emptyView)
        if topUpView.frame.contains(touchPoint) {
            return false
        }
        return true
    }
}
