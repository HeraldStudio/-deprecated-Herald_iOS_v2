//
//  NoticeTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    var staticLabel = UILabel()
    let noticeTableView = UITableView()
    
    var noticeList : [NoticeModel] = [] { didSet { updateUI() } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        setupSubViews()
        noticeTableView.register(NoticeCell.self, forCellReuseIdentifier: "noticeCell")
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.isScrollEnabled = false
        noticeTableView.allowsSelection = false
        noticeTableView.estimatedRowHeight = 95
    }
    
    private func setupSubViews() {
        staticLabel.into(contentView).top(15).centerX().height(20).width(80).text("通知公告").align(.center).font(16,.bold)
        noticeTableView.into(contentView).below(staticLabel, 8).left(0).right(0).bottom(0).height(1000)
    }
    
    private func updateUI() {
        noticeTableView.reloadData()
    }
}

extension NoticeTableViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: screenRect.width - 20, height: 0))
        let notice = noticeList[indexPath.row]
        label.numberOfLines = 0
        label.text = notice.title
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        let size = label.sizeThatFits(CGSize(width: screenRect.width - 40, height: 0))
        return 10 + size.height + 5 + 30 + 8 + 1
    }
}

extension NoticeTableViewCell : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NoticeCell
        cell.notice = noticeList[indexPath.row]
        return cell
    }
    
}
