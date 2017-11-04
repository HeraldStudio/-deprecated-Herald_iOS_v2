import UIKit
import RxSwift

/// 一个简单的下拉刷新控件。使用该控件要注意以下几点（尤其最后五条）：
//- 0、本控件可以使用 contentView 设置子控件，也可以留空（只有下拉时才会出现）
//- 1、设置子控件时不要用 addSubView ，而是直接设置 contentView 成员
//- 2、父控件是 UIScrollView 或其子类，如 UITableView
//- 3、本控件要放在最顶部，例如可以作为 UITableView 的 tableHeaderView 使用
//- 4、初始 contentOffset.y 必须为零，因此不能放在开启 translucent 属性的 UINavigationBar 下
/// 5、将本控件添加到父控件前，要先设置 refresher
/// 6、在父控件 scrollViewDidScroll 代理方法中要调用 syncApperance()
/// 7、在父控件 scrollViewWillBeginDragging 代理方法中要调用 beginDrag()
/// 8、在父控件 scrollViewDidEndDragging 代理方法中要调用 endDrag()
/// 9、显示 progressDialog 的时候不会触发刷新

/*let eggs = [
 "诶嘿？",
 "喂喂~",
 "主人你在发呆吗？",
 "妖妖灵吗？这里有人虐待小猴纸！",
 "场面已经控制不住了！",
 "要不，小猴陪你说说话吧。"
 ]*/

class SwipeRefreshHeader : UIView {
    
    /// 文字不透明度从0淡入到1的距离
    let fadeDistance : CGFloat = 150
    
    /// 触发刷新的最小滑动距离
    let refreshDistance : CGFloat = 60
    
    /// 嵌入的子视图，若非空，则以它的高度作为下拉刷新控件的初始高度
    var contentView : UIView?
    
    /// 刷新提示文本
    let refresh = UILabel()
    
    /// 刷新触发的事件
//    var refresher : (() -> Void)?
    
    /// 改用RxSwift Variable
    var isEvent = Variable<Bool>(false)
    
    /// 下拉刷新控件没有拉伸时的原始高度
    var realHeight = CGFloat(0)
    
    /// 下拉刷新中的文字，两个不能相同否则会出现未定义行为
    let tipTextOff = "下拉刷新"
    let tipTextOn = "松手刷新"
    
    /// 顶部边距
    var topPadding = CGFloat(0)
    
    /// 下拉刷新是否启用，若没有启用，将不会显示
    var _enabled = true
    
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 视图被展示时的操作
    override func didMoveToSuperview() {
        
        if var superStaticView = superview {
            //适配UITableView
            if let v = superStaticView.superview, superStaticView is UIScrollView {
                superStaticView = v
            }
            
            // 先移除所有子视图，以防万一
            removeAllSubviews()
            
            // 计算原始高度并添加子视图
            realHeight = CGFloat(0)
            if contentView != nil {
                realHeight = contentView!.frame.height
                topPadding = contentView!.frame.minY
                addSubview(contentView!)
            }
            
            // 计算尺寸
            self.frame = CGRect(x: 0, y: 0, width: superStaticView.frame.width, height: realHeight + topPadding)
            
            // 添加刷新提示文字
            refresh.clipsToBounds = true
            refresh.frame = CGRect(x: 0, y: 0, width: superStaticView.frame.width, height: 0)
            refresh.textAlignment = .center
            refresh.font = UIFont.systemFont(ofSize: 14)
            refresh.textColor = .lightGray
            addSubview(refresh)
            
            // 首次重绘
            syncApperance()
        }
    }
    
    /// 重绘
    func syncApperance () {
        if superview == nil {
            return
        }
        let x = (superview! as! UIScrollView).contentOffset.x
        let y = (superview! as! UIScrollView).contentOffset.y
        
        // 更新刷新提示文字内容
        refresh.text = isHighlight ? tipTextOn : tipTextOff
        refresh.frame = CGRect(x: x, y: min(y, 0), width: frame.width, height: -min(y, 0))
        refresh.alpha = min(1, -min(y + 15, 0) / CGFloat(15))
    }
    
    /// 记录是否正在拖动
    // 一开始的方案没有这个 dragging，也没有 beginDrag 函数，但是这导致了一个小问题，假如触发刷新的距离是100，
    // 在拉到90的位置时松手，保留一个向下的速度，则由于惯性，松手后还有可能超过100，导致闪现出[REFRESH]字样
    // 但没有触发刷新，造成视觉上的不一致。因此有了这个 dragging 变量，只有拖动的时候才会显示[REFRESH]，
    // 不拖动时即使距离超过了触发距离也只显示REFRESH。
    var dragging = false
    
    var isHighlight : Bool {
        let y = (superview! as! UIScrollView).contentOffset.y
        let val = -y >= refreshDistance && dragging && !UIViewController.progressDialogShown
        return val
    }
    
    /// 记录拖动开始，需要在父视图代理中调用
    func beginDrag () {
        dragging = true
    }
    
    /// 记录拖动结束，需要在父视图代理中调用
    func endDrag () {
        dragging = false
        //changeTime = 0
        guard let text = refresh.text else { return }
        if text == tipTextOn {
//            refresher?()
            isEvent.value = true
        }
        isEvent.value = false
    }
}

