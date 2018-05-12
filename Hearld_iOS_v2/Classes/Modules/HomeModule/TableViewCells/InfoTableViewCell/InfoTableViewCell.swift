//
//  InfoTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Realm
import RealmSwift
import SVProgressHUD

class InfoTableViewCell: UITableViewCell {
    
    // Mark - UI stuff
    var staticLabel = UILabel()
    var nameLabel = UILabel()
    var identityLabel = UILabel()
    var logoutButton = UIButton()
    var cardExtraButton = UIButton()
    var peButton = UIButton()
    var lectureButton = UIButton()
    var strpButton = UIButton()
    var gradeButton = UIButton()
    
    let buttonWidth = (screenRect.width - 10) / 5
    
    var underLine_1 = UIView()
    var underLine_2 = UIView()
    
    var verticalLine_1 = UIView()
    var verticalLine_2 = UIView()
    var verticalLine_3 = UIView()
    var verticalLine_4 = UIView()
    
    // Mark - 实现上弹视图
    var popViewFrame: CGRect?
    var currentTag: Int?
    
    var emptyView = UIView(frame: screenRect)
    var lectureView = LectureView()
    var srtpView = SRTPView()
    var gpaView = GPAView()
    var cardView = CardView()
    var delegate : addSubViewProtocol?

    var infoList: [infoItem] = [] { didSet { updateUI() } }
    
    // Mark : ViewModel
    var strpViewModel = SRTPViewModel.shared
    var lectureViewModel = LectureViewModel.shared
    var gpaViewModel = GPAViewModel.shared
    var cardViewModel = CardViewModel.shared
    let bag = DisposeBag()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        setupSubviews()
        
        // 订阅是否登录的信息
//        isLoginVariable.asObservable().subscribe(
//            onNext:{ isLogin in
//                if isLogin {
//                    self.prepareData()
//                }else{
//                    self.user = User()
//                    self.prepareData()
//                }
//        }).addDisposableTo(bag)
        
        /// 分别订阅5个Button对应的网络请求
        subscribeButton()
        
        /// 初始化emptyView
        initialEmptyView()
        
        /// 5个Button addTarget
        addTargets()
    }
    
    private func subscribeButton() {
        // 订阅card请求
        cardViewModel.cardList.subscribe(
            onNext: { cardArray in
                let desc = "余额\n"
                var balance = "..."
                let realm = try! Realm()
                if let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first {
                    balance = String(user.balance)
                }
                self.dealWithButton(self.cardExtraButton, number: balance, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Secondary)
        }, onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        // 订阅strp请求
        strpViewModel.SRTPList.subscribe(
            onNext:{ strpArray in
                let desc = "STRP\n"
                let number = strpArray[0].credit
                self.dealWithButton(self.strpButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Secondary)
        },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        // 订阅Lecture请求
        lectureViewModel.LectureList.subscribe(
            onNext: { lectureArray in
                let desc = "讲座\n"
                let number = lectureArray.count
                self.dealWithButton(self.lectureButton, number: String(number), desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Secondary)
            },
            onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        // 订阅GPA请求
        gpaViewModel.GPAList.subscribe(
            onNext: { gpaArray in
                let desc = "绩点\n"
                var gpa = "..."
                let realm = try! Realm()
                if let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first {
                    gpa = user.gpa
                }
                self.dealWithButton(self.gradeButton, number: gpa, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Secondary)
            },
            onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
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
    
    private func addTargets() {
        cardExtraButton.tag = 101
        cardExtraButton.addTarget(self, action: #selector(popView(_:)), for: .touchDown)
        
        peButton.tag = 102
        peButton.addTarget(self, action: #selector(popView(_:)), for: .touchDown)
        
        lectureButton.tag = 103
        lectureButton.addTarget(self, action: #selector(popView(_:)), for: .touchDown)
        
        strpButton.tag = 104
        strpButton.addTarget(self, action: #selector(popView(_:)), for: .touchDown)
        
        gradeButton.tag = 105
        gradeButton.addTarget(self, action: #selector(popView(_:)), for: .touchDown)
    }
    
    @objc private func popView(_ sender: UIButton) {
        if sender.titleLabel?.text != "..." {
            switch sender.tag {
            case 101:
                // Mark: Card
                currentTag = 101
                cardView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cardView.cardViewModel.prepareData(isRefresh: false) {
                    let totalRowHeight = self.cardView.cardViewModel.cardModels.count * 60
                    let finalHeight = (CGFloat)(160 + totalRowHeight)
                    self.popViewFrame = CGRect(x: 0, y: screenRect.height, width: screenRect.width, height: finalHeight)
                    self.cardView.frame = self.popViewFrame!
                    
                    // animation
                    UIView.animate(withDuration: 0.3) {
                        self.cardView.frame.origin = CGPoint(x: 0, y: screenRect.height - finalHeight - 49 - 37)
                    }
                    self.emptyView.addSubview(self.cardView)
                    self.delegate?.addSubViewFromCell(self.emptyView)
                    self.delegate?.changeAlphaTo(0.3)
                }
            case 103:
                // Mark: Lecture
                currentTag = 103
                lectureView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                lectureView.lectureViewModel.prepareData(isRefresh: false) {
                    let totalRowHeight = self.lectureView.lectureViewModel.lectureModels.count * 37
                    let finalHeight = (CGFloat)(125 + totalRowHeight)
                    self.popViewFrame = CGRect(x: 0, y: screenRect.height, width: screenRect.width, height: finalHeight)
                    self.lectureView.frame = self.popViewFrame!
                    
                    // animation
                    UIView.animate(withDuration: 0.3) {
                        self.lectureView.frame.origin = CGPoint(x: 0, y: screenRect.height - finalHeight - 49 - 37)
                    }
                    self.emptyView.addSubview(self.lectureView)
                    self.delegate?.addSubViewFromCell(self.emptyView)
                    self.delegate?.changeAlphaTo(0.3)
                }
            case 104:
                // Mark: Srtp
                currentTag = 104
                srtpView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                var totalHeight : CGFloat = 0
                srtpView.srtpViewModel.prepareData(isRefresh: false) {
                    let label = UILabel(frame: CGRect(x: 10, y: 10, width: screenRect.width - 30, height: 0))
                    var size : CGSize
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)

                    for srtp in self.srtpView.srtpViewModel.srtpList {
                        label.text = srtp.project
                        size = label.sizeThatFits(CGSize(width: screenRect.width - 30, height: 0))
                        totalHeight += (size.height + 45)
                    }
                    let finalHeight = (CGFloat)(125 + totalHeight)
                    self.popViewFrame = CGRect(x: 0, y: screenRect.height, width: screenRect.width, height: finalHeight )
                    self.srtpView.frame = self.popViewFrame!

                    // animation
                    UIView.animate(withDuration: 0.3) {
                        self.srtpView.frame.origin = CGPoint(x: 0, y: screenRect.height - totalHeight - 49 - 37 - 125)
                    }
                    self.emptyView.addSubview(self.srtpView)
                    self.delegate?.addSubViewFromCell(self.emptyView)
                    self.delegate?.changeAlphaTo(0.3)
                }
            case 105:
            // Mark: GPA
                currentTag = 105
                gpaView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                gpaView.gpaViewModel.prepareData(isRefresh: false) {
                    let totalRowHeight = self.gpaView.gpaViewModel.gpaModels.count * 37
                    let finalHeight = (CGFloat)(125 + totalRowHeight)
                    self.popViewFrame = CGRect(x: 0, y: screenRect.height, width: screenRect.width, height: finalHeight)
                    self.gpaView.frame = self.popViewFrame!
                    
                    // animation
                    UIView.animate(withDuration: 0.3) {
                        self.gpaView.frame.origin = CGPoint(x: 0, y: screenRect.height - finalHeight - 49 - 37)
                    }
                    self.emptyView.addSubview(self.gpaView)
                    self.delegate?.addSubViewFromCell(self.emptyView)
                    self.delegate?.changeAlphaTo(0.3)
                }
            default:
                return
            }
        }
    }
    
    // UIGestureRecognizerDelegate
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: emptyView)
        // 如果touchPoint在上弹窗口内，则不响应手势
        switch currentTag {
        case 101:
            if self.cardView.frame.contains(touchPoint) {
                return false;
            }
        case 103:
            if self.lectureView.frame.contains(touchPoint) {
                return false
            }
        case 104:
            if self.srtpView.frame.contains(touchPoint) {
                return false
            }
        case 105:
            if self.gpaView.frame.contains(touchPoint) {
                return false
            }
        default:
            return false
        }
        return true
    }
    
    // 滑动手势popOff上弹窗口
    func swipe(gesture: UISwipeGestureRecognizer) {
        popOffView()
    }
    
    // tap手势popOff上弹窗口
    @objc private func dismissDropDownView(_ sender: UITapGestureRecognizer) {
        popOffView()
    }
    
    private func popOffView() {
        switch currentTag {
        case 101:
            UIView.animate(withDuration: 0.3, animations: {
                self.cardView.frame.origin = CGPoint(x: 0, y: screenRect.height)
            }) { finished in
                self.cardView.removeFromSuperview()
                self.emptyView.removeFromSuperview()
                self.delegate?.changeAlphaTo(1)
            }
        case 103:
            UIView.animate(withDuration: 0.3, animations: {
                self.lectureView.frame.origin = CGPoint(x: 0, y: screenRect.height)
            }) { finished in
                self.lectureView.removeFromSuperview()
                self.emptyView.removeFromSuperview()
                self.delegate?.changeAlphaTo(1)
            }
        case 104:
            UIView.animate(withDuration: 0.3, animations: {
                self.srtpView.frame.origin = CGPoint(x: 0, y: screenRect.height)
            }) { finished in
                self.srtpView.removeFromSuperview()
                self.emptyView.removeFromSuperview()
                self.delegate?.changeAlphaTo(1)
            }
        case 105:
            UIView.animate(withDuration: 0.3, animations: {
                self.gpaView.frame.origin = CGPoint(x: 0, y: screenRect.height)
            }) { finished in
                self.gpaView.removeFromSuperview()
                self.emptyView.removeFromSuperview()
                self.delegate?.changeAlphaTo(1)
            }
        default:
            return
        }
    }
    
    private func setupSubviews() {
        // 信息板
        staticLabel.into(contentView).top(15).centerX().height(20).width(50).text("信息板").font(16,.bold)
        
        // 名字
        nameLabel.into(contentView).below(staticLabel,8).left(15).height(30).font(16,.regular).color(HeraldColorHelper.Regular)
        
        // 身份
        identityLabel.into(contentView).after(nameLabel,15).below(staticLabel,18).height(15).font(13,.regular).color(HeraldColorHelper.Secondary)
        
        // 注销按钮
//        logoutButton.into(contentView).below(staticLabel,10).right(15)
        
        // 画线
        underLine_1.into(contentView).below(nameLabel,4).width(screenRect.width).height(1).background(HeraldColorHelper.line)
        
        // 一卡通余额按钮
        cardExtraButton.into(contentView).below(underLine_1,10).left(3).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线1
        verticalLine_1.into(contentView).below(underLine_1,10).after(cardExtraButton,0).width(1).height(70).background(HeraldColorHelper.line)
        
        // 跑操按钮
        peButton.into(contentView).below(underLine_1,10).after(verticalLine_1,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线2
        verticalLine_2.into(contentView).below(underLine_1,10).after(peButton,0).width(1).height(70).background(HeraldColorHelper.line)
        
        // 讲座按钮
        lectureButton.into(contentView).below(underLine_1,10).after(verticalLine_2,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线3
        verticalLine_3.into(contentView).below(underLine_1,10).after(lectureButton,0).width(1).height(70).background(HeraldColorHelper.line)
        
        // STRP按钮
        strpButton.into(contentView).after(verticalLine_3,0).below(underLine_1,10).width(buttonWidth).height(70).numberOfLines(0).align(.center)
        
        // 竖直线4
        verticalLine_4.into(contentView).below(underLine_1,10).after(strpButton,0).width(1).height(70).background(HeraldColorHelper.line)
        
        // 绩点按钮
        gradeButton.into(contentView).below(underLine_1,10).after(verticalLine_4,0).width(buttonWidth).height(70).numberOfLines(0).align(.center)

        // 画线
        underLine_2.into(contentView).below(cardExtraButton,4).width(screenRect.width).height(1).background(HeraldColorHelper.line).bottom(1)
    }
    
    private func updateUI() {
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first
        
        // 姓名与身份
        nameLabel.text = user?.username
        identityLabel.text = user?.identity
        
        for info in infoList {
            var number: String
            var desc: String
            switch info {
            case .cardExtra:
                desc = "余额\n"
                number = "···"
                dealWithButton(cardExtraButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Regular)
            case .pe:
                desc = "跑操\n"
                number = "···"
                dealWithButton(peButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Regular)
            case .lecture():
                desc = "讲座\n"
                number = "···"
                dealWithButton(lectureButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Regular)
            case .srtp():
                desc = "STRP\n"
                number = "···"
                dealWithButton(strpButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Regular)
            case .grade():
                desc = "绩点\n"
                number = "···"
                dealWithButton(gradeButton, number: number, desc: desc, numSize: 17, numFont: .regular, numColor: HeraldColorHelper.Primary, descSize: 15, descFont: .semibold, descColor: HeraldColorHelper.Regular)
            }
        }
    }
    
    fileprivate func dealWithButton(_ button: UIButton, number: String, desc: String, numSize: CGFloat, numFont: FontWeight, numColor: UIColor, descSize: CGFloat, descFont: FontWeight, descColor: UIColor) {
        let text = desc + number
        
        let textAttrString = NSMutableAttributedString.init(string: text)
        
        let descIndex = desc.length()
        let numberIndex = number.length()
        
        let descRange = NSRange(location: 0, length: descIndex)
        let numberRange = NSRange(location: descIndex, length: numberIndex)
        
        textAttrString.font(descSize, descFont, descRange).color(descColor,descRange).font(numSize, numFont, numberRange).color(numColor,numberRange)
        button.setAttributedTitle(textAttrString, for: .normal)
    }
    
}
