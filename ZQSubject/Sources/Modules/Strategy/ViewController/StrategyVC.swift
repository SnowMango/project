
import UIKit
import WMZPageController

class StrategyVC: WMZPageController {
    
    lazy var header: StrategyTableViewHeader = StrategyTableViewHeader()
    var bgImgv:UIImageView?
    lazy var titleParam: WMZPageParam = {
        let pageParam = PageParam()
        pageParam.wMenuDefaultIndex = 0
        pageParam.wMenuHeight = wScale(44)
        pageParam.wTopSuspension = true
        pageParam.wBounces = true
        pageParam.wMenuAnimal = PageTitleMenuPDD
        pageParam.wMenuTitleSelectUIFont = .kFontScale(16)
        pageParam.wMenuTitleUIFont = .kFontScale(16)
        pageParam.wMenuTitleColor = .kText1
        pageParam.wMenuTitleSelectColor = .kText2
        pageParam.wMenuIndicatorColor = .kTheme
        pageParam.wMenuIndicatorHeight = 4
        pageParam.wMenuIndicatorWidth = wScale(22)
        pageParam.wMenuIndicatorRadio = 2
        pageParam.wMenuIndicatorY = wScale(9)
        pageParam.wMenuBgColor = .kBackGround
        pageParam.wMenuInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        pageParam.wCustomNaviBarY = { old in
            return wScale(124) + kSafeTopH()
        }
        //开始切换
        pageParam.wEventBeganTransferController = { (oldVC,newVC,oldIndex,newIndex) in
            print("开始切换 -> 新\(newIndex)--旧\(oldIndex)")
        }
        //完成切换
        pageParam.wEventEndTransferController = {[weak self] (oldVC,newVC,oldIndex,newIndex) in
            print("完成切换 -> 新\(newIndex)--旧\(oldIndex)")
            if let vc = newVC as? StrategyArticlesVC {
                vc.requestNew()
            }
        }
        return pageParam
    }()
    
   
    private var products: [StrategyProduct] = []
    private var banners: [AppResource.ResourceData] = []
    var categories: [AppResource.ResourceData] = []
    override func viewDidLoad() {
        initUI()
        super.viewDidLoad()
        
        view.backgroundColor = .kBackGround
       
        hiddenNavigationBarWhenShow = true
        downSc?.backgroundColor = .clear
        downSc?.mj_header = RefreshHeader(refreshingTarget: self, refreshingAction: #selector(initData))
        
        if let category = AppManager.shared.resource(with: "market_information_classification"){
            self.categories = category.data
        }
        
        if let banner = AppManager.shared.resource(with: "QS_middle_banner") {
            self.banners = banner.data
        }
        initData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let bgImgv = self.bgImgv {
            self.view.sendSubviewToBack(bgImgv)
        }
        for view in self.view.subviews {
            if let v = view as? WMZPageView {
                v.backgroundColor = .clear
                for t in v.subviews {
                    t.backgroundColor = .clear
                }
            }
        }
    }
    
    private func initUI() {
        let bgImgv = UIImageView(image: UIImage(named: "strategy_bg"))
        self.bgImgv = bgImgv
        addSubview(bgImgv)
        bgImgv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(bgImgv.snp.width).multipliedBy(354.5/375.0)
        }
       
        let titleImgv = UIImageView(image: UIImage(named: "strategy_title"))
        addSubview(titleImgv)
        titleImgv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wScale(33)+kSafeTopH())
            make.centerX.equalToSuperview()
        }
        
        let descLb = UILabel()
        descLb.text = "智选投资决策，收益更可期"
        descLb.font = .kFontScale(16)
        descLb.textColor = UIColor("475165")
        addSubview(descLb)
        descLb.snp.makeConstraints { make in
            make.top.equalTo(titleImgv.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension StrategyVC {
    ///初始化接口
    @objc private func initData() {
        
        NetworkManager.shared.request(AuthTarget.strategyList) {(result: NetworkPageResult<StrategyProduct>) in
            do {
                let response = try result.get()
                self.products = response.records
                self.refreshUI()
            } catch {
                
            }
        }
        if let resources = AppManager.shared.appResources {
            if  let category = resources.first(where: {  $0.resourceKey == "market_information_classification" }) {
                self.categories = category.data
            }
            if  let banner = resources.first(where: {  $0.resourceKey == "QS_middle_banner" }){
                self.banners = banner.data
            }
            self.downSc?.mj_header?.endRefreshing()
        }else {
            self.downSc?.mj_header?.endRefreshing()
        }
        
    }
    
    private func loadLocalData() {
    
//        refreshUI()
    }
    
    private func refreshUI() {
        let headerH = header.layout(self.products, banners: self.banners)
        self.header.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerH)
        titleParam.wMenuHeadView = { [weak self] in
            return self?.header
        }
        self.header.ads_L02 = self.products
        self.header.ads_L03 = self.banners
        self.header.setupUI()
        
        let titles:[String] =  self.categories.map { $0.resourceName ?? "-" }
        let vcs:[StrategyArticlesVC] =  self.categories.map {
            let vc = StrategyArticlesVC()
            vc.typeId = $0.resourceUrl
            return vc
        }
        if titles.count <= 3 {
            titleParam.wMenuTitleWidth = SCREEN_WIDTH/CGFloat(max(titles.count, 1))
        }
       
        titleParam.wTitleArr =  titles
        titleParam.wControllers = vcs
        
        vcs.first?.requestNew()
        
        //想要header高度发生变化的话需要重新设置param,如果只是wControllers不需要这样设置,
        //所以这里只需要在高度发生变化的时候触发设置param就可以了
        self.param = titleParam
        
        
    }

    ///刷新，重新请求初始化接口
    @objc func refreshInit() {
        initData()
    }
}
