
import UIKit
import WMZPageController

class StrategyArticlesVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.backgroundColor = .clear
        tab.showsVerticalScrollIndicator = false
        tab.separatorStyle = .none
        tab.rowHeight = wScale(117)
        tab.delegate = self
        tab.dataSource = self
        tab.registerCell(cls: StrategyArticlesCell.self)
        tab.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        view.addSubview(tab)
        tab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        return tab
    }()
    
    
    ///当前页码
    var currentPage: Int = 1
    var typeId: String?
    
    /// 文章列表数据源
    var articleDatas: [StrategyArticleModel] = [] {
        didSet {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            updateFooterView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        updateFooterView()
    }
    
    // 让footerView紧贴tableView的底部
    private func updateFooterView() {

        tableView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            self?.requestMore()
        })
        tableView.layoutIfNeeded()
        
        let tableH = tableView.bounds.height
        let contentH = tableView.contentSize.height
        var topConstrain = 0.0
        if tableH > contentH {
            topConstrain = tableH - contentH
        }
        
    }
}

extension StrategyArticlesVC {
    func requestMore()  {
        requestList(page: currentPage + 1,true)
    }
    
    func requestNew()  {
        requestList(page: 1, false)
    }
    ///请求文章列表
    func requestList(page:Int, _ more: Bool = false) {
        guard let typeId = typeId, let id = Int(typeId) else {
            self.tableView.mj_footer?.endRefreshing()
            return
        }
        NetworkManager.shared.request(AuthTarget.articleList(current: page, size: 10, type: id)) { (result: NetworkPageResult<StrategyArticleModel>) in
            self.tableView.mj_footer?.endRefreshing()
            do {
                self.currentPage = page
                let response = try result.get()
                if more {
                    if response.records.count > 0 {
                        self.articleDatas += response.records
                    }else {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else {
                    self.articleDatas = response.records
                }
            } catch NetworkError.server(_ ,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误刷新失败")
            }
        }
    }
}

extension StrategyArticlesVC: UITableViewDelegate,UITableViewDataSource,WMZPageProtocol {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReuseCell(StrategyArticlesCell.self, indexPath: indexPath)
        cell.articleModel = articleDatas[indexPath.row]
        cell.rowPosition = TableViewCellPosition.getPosition(total: articleDatas.count, current: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = articleDatas[indexPath.row]
        JumpManager.jumpToWeb(AppLink.news(id: item.id).path)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return wScale(106)
    }
    
    // 第三方处理手势冲突时会调用此方法，必不可少
    func getMyScrollView() -> UIScrollView {
        return tableView
    }

}
