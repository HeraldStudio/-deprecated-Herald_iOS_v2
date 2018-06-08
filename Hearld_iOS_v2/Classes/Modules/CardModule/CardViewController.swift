//
//  CardViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 27/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD
import Realm
import RealmSwift

class CardViewController: UIViewController {
    
    /* UI stuff */
    var balanceLabel = UILabel()
    var comsumeTimesLabel = UILabel()
    var topUpButton = UIButton()
    var cardTableView = UITableView()
    var totalCostlabel = UILabel()
    var loadButton = UIButton()
    
    var containerView_1 = UIView()
    var containerView_2 = UIView()
    
    /* rxswift */
    let cardViewModel = CardViewModel.shared
    let bag = DisposeBag()
    typealias SectionTableModel = SectionModel<String,CardModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "一卡通"
        layoutUI()
        
        /* CardTableViewCell */
        cardTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardTableViewCell")
        cardTableView.showsVerticalScrollIndicator = false
        setConfigureCell()
        
        /* 订阅Card请求 */
        cardViewModel.cardList.subscribe(
            onNext: { cardArray in
                let realm = try! Realm()
                let currentUser = realm.objects(User.self).filter("uuid == '\(HeraldUserDefault.uuid!)'").first!
                
                /* 动态修改约束 */
                self.cardTableView.changeHeight(to: CGFloat(self.cardViewModel.cardModels.count * 60))
                
                self.balanceLabel.text = "卡余额 " + String(currentUser.balance)
                self.comsumeTimesLabel.text = "今日消费次数 " + String(cardArray.count)
                let totalCost = cardArray.reduce(0, { temp, card in
                    return temp + card.amount
                })
                if cardArray.count > 0 {
                    self.totalCostlabel.text = cardArray[0].time +  "至今 总支出 " + String(totalCost)
                } else {
                    self.totalCostlabel.text = "今天无支出"
                }
                
                self.cardTableView.dataSource = nil
                Observable.just(self.createSectionModel(cardArray))
                          .bind(to: self.cardTableView.rx.items(dataSource: self.dataSource))
                          .addDisposableTo(self.bag)
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        /* 订阅充值Button点击事件 */
        topUpButton.rx.tap.asObservable().subscribe({_ in
            self.navigationController?.pushViewController(TopUpViewController(), animated: true)
        }).addDisposableTo(bag)
        
        /* 订阅加载历史Button点击事件 */
        loadButton.rx.tap.asObservable().subscribe({_ in
            self.cardViewModel.prepareData(isExpand: true, completionHandler: {})
        }).addDisposableTo(bag)
        
        cardViewModel.prepareData(isRefresh: false, completionHandler: {})
    }

    private func layoutUI() {
        view.background(UIColor.white)
        if let navigationController = self.navigationController as? MainNavigationController {
            // 容器View
            containerView_1.into(view).top(navigationController.getHeight() + 70).left(40).right(40).height(30)
            
            // 余额
            balanceLabel.into(containerView_1).top(0).bottom(0).left(0).width(110).background(HeraldColorHelper.LabelBgColor.PrimaryBg).font(16,.semibold).align(.center)
            
            // 充值
            topUpButton.into(containerView_1).top(0).bottom(0).right(0).width(45).background(HeraldColorHelper.LabelBgColor.PrimaryBg)
            let textAttrString = NSMutableAttributedString.init(string: "充值")
            textAttrString.font(16, FontWeight.semibold, NSMakeRange(0, 2))
            topUpButton.setAttributedTitle(textAttrString, for: .normal)
            
            // 消费次数
            comsumeTimesLabel.into(containerView_1).top(0).bottom(0).after(balanceLabel, 5).before(topUpButton,5).background(HeraldColorHelper.LabelBgColor.PrimaryBg).font(16,.semibold).align(.center)
            
            // TableView
            cardTableView.into(view).below(containerView_1, 10).left(5).right(5).height(CGFloat(cardViewModel.cardModels.count * 60))
            
            // 容器View
            containerView_2.into(view).below(cardTableView,10).left(50).right(50).height(30)
            
            // 总支出
            totalCostlabel.into(containerView_2).top(0).left(0).bottom(0).width(200).background(UIColor.white).font(15,.semibold).align(.center).color(HeraldColorHelper.GeneralColor.Secondary)
            
            // 加载前一天
            loadButton.into(containerView_2).top(0).after(totalCostlabel, 5).right(0).bottom(0).width(90).background(HeraldColorHelper.LabelBgColor.PrimaryBg)
            let yet_textAttrString = NSMutableAttributedString.init(string: "加载前一天")
            yet_textAttrString.font(15, FontWeight.semibold, NSMakeRange(0, 5))
            loadButton.setAttributedTitle(yet_textAttrString, for: .normal)
        }
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
            cell.card = item
            return cell
        }
    }
    
    private func createSectionModel(_ cardList: [CardModel]) -> [SectionTableModel] {
        return [SectionTableModel(model: "", items: cardList)]
    }
}
