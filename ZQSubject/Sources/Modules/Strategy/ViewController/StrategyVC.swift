
import UIKit
import WMZPageController
import RxCocoa
import RxSwift

class StrategyVC: WMZPageController {
    var disposeBag = DisposeBag()
    lazy var header: StrategyTableViewHeader = StrategyTableViewHeader()
    var bgImgv:UIImageView?
    lazy var titleParam: WMZPageParam = {
        let pageParam = PageParam()
        pageParam.wMenuDefaultIndex = 0
        pageParam.wMenuHeight = wScale(44)
        pageParam.wTopSuspension = true
        pageParam.wBounces = true
        pageParam.wMenuAnimal = PageTitleMenuPDD
        pageParam.wMenuTitleSelectUIFont = .kScale(16)
        pageParam.wMenuTitleUIFont = .kScale(16)
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
            return wScale(144) + kSafeTopH()
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
            make.height.equalTo(wScale(354))
        }
       
        let titleImgv = UIImageView(image: UIImage(named: "strategy_title"))
        addSubview(titleImgv)
        titleImgv.snp.makeConstraints { make in
            make.top.equalTo(wScale(64))
            make.centerX.equalToSuperview()
        }
        
        let descLb = UILabel()
        descLb.text = "智选投资决策，收益更可期"
        descLb.font = .kScale(16)
        descLb.textColor = UIColor("475165")
        addSubview(descLb)
        descLb.snp.makeConstraints { make in
            make.top.equalTo(titleImgv.snp.bottom).offset(wScale(8))
            make.centerX.equalToSuperview()
        }
    
        let searchBar: UIView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(17)
        }
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { _ in
                Router.shared.route("/search/stock")
            })
            .disposed(by: disposeBag)
        searchBar.addGestureRecognizer(tapBackground)
        
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(descLb.snp.bottom).offset(wScale(15))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(34))
        }
        
        let searchLogo = UIImageView(image: UIImage(named: "search.logo"))
        searchBar.addSubview(searchLogo)
        searchLogo.snp.makeConstraints { make in
            make.left.equalTo(wScale(18))
            make.centerY.equalToSuperview()
        }
        
        let placehoder = UILabel()
        placehoder.text = "输入查询内容"
        placehoder.font = .kScale(14)
        placehoder.textColor = UIColor("#CBCBCB")
        searchBar.addSubview(placehoder)
        placehoder.snp.makeConstraints { make in
            make.left.equalTo(searchLogo.snp.right).offset(wScale(8))
            make.centerY.equalToSuperview()
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
                self.refreshUI()
            }
        }
        if let resource = AppManager.shared.resource(with: "market_information_classification") {
            self.categories = resource.data
        }
        if let resource = AppManager.shared.resource(with: "QS_middle_banner") {
            self.banners = resource.data
        }
        self.downSc?.mj_header?.endRefreshing()
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
