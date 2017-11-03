//
//  ActivityViewController.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources
import SDWebImage
import SVProgressHUD

class ActivityViewController: UIViewController {

    var activityTableView = UITableView()
    var page = 0
    
    var viewModel = ActivityViewModel()
    let bag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>()
    typealias SectionTableModel = SectionModel<String,ActivityModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityTableView)
        layoutSubviews()
        
        activityTableView.delegate = self
        activityTableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "Activity")
        setConfigureCell()
        
        viewModel.ActivityList.subscribe(
            onNext:{ activityArray in
                self.activityTableView.dataSource = nil
                Observable.just(self.createSectionModel(activityArray))
                    .bind(to: self.activityTableView.rx.items(dataSource: self.dataSource))
                    .addDisposableTo(self.bag)
            },
            onError:{ error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).addDisposableTo(bag)
        
        //PrepareData
        viewModel.prepareData()
    }
    
    private func setConfigureCell() {
        dataSource.configureCell = {(_,tv,indexPath,item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Activity", for: indexPath) as! ActivityTableViewCell
            
            let rich_title = NSMutableAttributedString.init(string: item.title)
            let title_length = (item.title as NSString).length
            rich_title.addAttributes(titleTextAttributes, range: NSMakeRange(0,title_length))
            cell.titleLabel.attributedText = rich_title
            
            let rich_state = NSMutableAttributedString.init(string: item.start_time)
            let state_length = (item.start_time as NSString).length
            rich_state.addAttributes(greyTextAttributes, range: NSMakeRange(0, state_length))
            cell.stateLabel.attributedText = rich_state
            
            cell.picture.sd_setImage(with: URL(string: ApiHelper.changeHTTPtoHTTPS(url: item.pic_url)) , placeholderImage: #imageLiteral(resourceName: "default_herald"))
            
            let rich_info = NSMutableAttributedString.init(string: item.introduction)
            let info_length = (item.introduction as NSString).length
            rich_info.addAttributes(greyTextAttributes, range: NSMakeRange(0, info_length))
            cell.infoLabel.attributedText = rich_info
            return cell
        }
    }
    
    private func createSectionModel(_ activityList: [ActivityModel]) -> [SectionTableModel]{
        return [SectionTableModel(model: "", items: activityList)]
    }
    
    private func layoutSubviews() {
        if let navigationController = self.navigationController as? MainNavigationController{
            activityTableView.frame = CGRect(x: 0,
                                             y: navigationController.getHeight(),
                                             width: screenRect.width,
                                             height: screenRect.height - navigationController.getHeight())
            activityTableView.top(navigationController.getHeight()).left(0).right(0).bottom(0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
