//
//  NoticeTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
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
        noticeTableView.into(contentView).top(0).left(0).right(0).bottom(0)
    }
    
    private func updateUI() {
        noticeTableView.reloadData()
    }
}

extension NoticeTableViewCell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
