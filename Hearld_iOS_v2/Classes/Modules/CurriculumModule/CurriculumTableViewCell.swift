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
    private var switchViewButton = UIButton()
    private var leftSwitchTermButton = UIButton()
    private var rightSwitchTermButton = UIButton()
    private var termLabel = UILabel()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    /* rxswift */
    typealias SectionTableModel = SectionModel<String,[CurriculumModel]>
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionTableModel>()
    
    let curriculumViewModel = CurriculumViewModel.shared
    let bag = DisposeBag()
    
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
        
        setConfigureCell()
        
        curriculumViewModel.curriculumTable.subscribe(
            onNext: { curriculumItems in
                print("motherfucker")
                self.collectionView.dataSource = nil
                Observable.just(self.createSectionModel(curriculumItems))
                          .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
                          .addDisposableTo(self.bag)
        }, onError: { error in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        curriculumViewModel.prepareData(isRefresh: true, completionHandler: {})
    }
    
    private func setupSubviews() {
       
        //切换视图Button
        switchViewButton.into(contentView).top(10).left(10).height(28).width(60).background(HeraldColorHelper.PrimaryBg)
        let textAttrString = NSMutableAttributedString.init(string: "周视图")
        textAttrString.font(15, FontWeight.semibold, NSMakeRange(0, 3))
        switchViewButton.setAttributedTitle(textAttrString, for: .normal)
        
        // 学期切换 tmp closed
        
        // 周视图CollectionView
        flowLayout.itemSize = CGSize(width: screenRect.width, height: 300)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 55, width: screenRect.width, height: 300) , collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(CurriculumCollectionViewCell.self, forCellWithReuseIdentifier: "CurriculumCollection")
        collectionView.into(contentView).left(0).right(0).below(switchViewButton,10).bottom(0)
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = { (_,cv,indexPath,item) in
            print("motherfucker")
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "CurriculumCollection", for: indexPath) as! CurriculumCollectionViewCell
            cell.curriculumList = item
            return cell
        }
    }
    
    private func createSectionModel(_ curriculumItems: [curriculumItem]) -> [SectionTableModel] {
        let formatTable = curriculumItems as [[CurriculumModel]]
        return [SectionTableModel(model: "", items: formatTable)]
    }
}
