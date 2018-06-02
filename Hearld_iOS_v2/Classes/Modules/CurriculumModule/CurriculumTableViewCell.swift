//
//  CurriculumTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Realm
import RealmSwift
import SVProgressHUD
import RxDataSources

class CurriculumTableViewCell: UITableViewCell {
    /* UI stuff */
    var switchViewButton = UIButton()
    var leftSwitchTermButton = UIButton()
    var rightSwitchTermButton = UIButton()
    var termLabel = UILabel()
    
//    var curriculumCollectionView = UICollectionView()
    
    /* rxswift */
//    let dataSource = RxCollectionViewSectionedReloadDataSource<String,[]>
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        
    }
}
