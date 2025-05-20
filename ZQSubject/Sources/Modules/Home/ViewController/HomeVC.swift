import UIKit
import MarqueeLabel
import MJRefresh
import Then

class HomeVC: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航栏
        hiddenNavigationBarWhenShow = true
        hiddenBackBtn = true
        //取消table的自动适配偏移
        setupUI()
       
        AppManager.shared.startTask()
        AppManager.shared.refreshKingkong()
        AppManager.shared.reloadKingkong()
        
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updataUserProfile), name: UserProfileDidUpdateName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppManager.shared.refreshUserInfo()
        if AppManager.shared.kingKongItems == nil {
            AppManager.shared.refreshKingkong {[weak self] in
                self?.reloadData()
            }
        }
        reloadData()
    }
    
    @objc func updataUserProfile() {
        self.reloadData()
    }
    
    @objc func contactUsClick() {
        JumpManager.jumpToWeb(AppLink.support.path)
    }
    
    func reloadData() {
        
        if let model = AppManager.shared.resource(with: "rolling_announcements") {
            noticeView.model = model.data.first
        }else{
            noticeView.model = nil
        }
        
        if let model = AppManager.shared.resource(with: "home_page_top_banner") {
            topBannerView.banners = model.data
            topBannerView.reloadData()
        }
        
        if  let model = AppManager.shared.resource(with:"home_page_middle_banner"){
            bannersView.banners = model.data
            bannersView.reloadData()
        }else {
            bannersView.isHidden = true
        }
        
        if  let model = AppManager.shared.resource(with: "home_information") {
            beginnerView.load(model.data )
        }else{
            beginnerView.isHidden = true
        }
        // 悬浮窗
        if let model = AppManager.shared.resource(with: "home_page_suspended_window"), let item = model.data.first {
            levitate.isHidden = false
            levitate.load(item)
        }else{
            levitate.isHidden = true
        }
        
        if let items = AppManager.shared.kingkong(with: 0) {
            self.categoriesView.isHidden = false
            self.categoriesView.categories = items
            let rows = items.count/4 + 1
            
            self.categoriesView.snp.updateConstraints { make in
                make.height.equalTo(rows*85)
            }
            self.categoriesView.collectionView.reloadData()
        } else {
            self.categoriesView.isHidden = true
        }
        
        if let item = AppManager.shared.resource(with: "service_status_dashboard_switch"), item.status == 0  {
            self.transactionStatusView.isHidden = false
        }else {
            self.transactionStatusView.isHidden = true
        }
        transactionStatusView.reloadData()
        
        if let item = AppManager.shared.resource(with: "user_story_switch"), item.status == 0 {
            self.userMessageView.isHidden = false
        }else {
            self.userMessageView.isHidden = true
        }
        
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(levitate)
//        view.addSubview(noticeView)
//        view.addSubview(contactUsBtn)
       
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(contactUsBtn)
        contentView.addSubview(noticeView)
        contentView.addSubview(backgourdView)
        backgourdView.addSubview(sectionsStack)
        scrollView.contentInsetAdjustmentBehavior = .never
        

        topView.addSubview(topBannerView)
        topView.addSubview(categoriesView)
        
        sectionsStack.addArrangedSubview(bannersView)
        sectionsStack.addArrangedSubview(transactionStatusView)
        sectionsStack.addArrangedSubview(beginnerView)
        sectionsStack.addArrangedSubview(bestStrategyView)
        sectionsStack.addArrangedSubview(rankingsView)
        sectionsStack.addArrangedSubview(userMessageView)
       
        bestStrategyView.isHidden = true
        rankingsView.isHidden = true
       
        levitate.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        noticeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(40)
            make.height.equalTo(wScale(22))
        }
        
        
        contactUsBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        topBannerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(64)
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(180))
            make.bottom.lessThanOrEqualTo(0)
        }
        categoriesView.snp.makeConstraints { make in
            make.top.equalTo(topBannerView.snp.bottom).offset(wScale(12))
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(80)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        backgourdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        sectionsStack.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.bottom.lessThanOrEqualTo(-30)
        }
        
        bannersView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(100))
        }
        
        transactionStatusView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }
        
        beginnerView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }
        
        bestStrategyView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }
        
        rankingsView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }
        
        userMessageView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        
    }
    
    lazy var noticeView: NoticeView = {
        return NoticeView().then {
            $0.isHidden = true
        }
    }()
    
    lazy var contactUsBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitle("客服", for: .normal)
            $0.setTitleColor(.kText2, for: .normal)
            $0.setImage(UIImage(named: "contact"), for: .normal)
            $0.titleLabel?.font = .kFontScale(14)
            $0.configuration = .plain()
            $0.configuration?.imagePadding = 6.0
            $0.addTarget(self, action: #selector(contactUsClick), for: .touchDown)
        }
    }()
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
            $0.mj_header = RefreshHeader(refreshingBlock: {
                self.getData()
            })
            $0.mj_header?.mj_h += kStatusBarH()
//            $0.mj_header?.ignoredScrollViewContentInsetTop -= kStatusBarH()*0.5
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
        }
    }()
    
    lazy var topView: UIView = {
        return UIView().then {
            $0.backgroundColor = .clear
        }
    }()
    
    lazy var topBannerView: TopBannerView = {
        return TopBannerView()
    }()
    
    lazy var  categoriesView: CategoriesView = {
        return CategoriesView()
    }()
    
    lazy var backgourdView: UIView = {
        return UIView().then {
            $0.backgroundColor = .kBackGround
        }
    }()
    lazy var sectionsStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 12
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    lazy var  bannersView: BannersView = {
        return BannersView()
    }()
    
    lazy var  transactionStatusView: ApplyTransactionStatusView = {
        return ApplyTransactionStatusView()
    }()
    
    lazy var  beginnerView: BeginnerView = {
        return BeginnerView()
    }()
    
    lazy var  bestStrategyView: BestStrategyView = {
        return BestStrategyView()
    }()
    
    lazy var  rankingsView: RankingsView = {
        return RankingsView()
    }()
    
    lazy var  userMessageView: UserMessageView = {
        return UserMessageView()
    }()
    
    lazy var  levitate:LevitateView  = {
        return LevitateView().then { $0.isHidden = true }
    }()
}

extension HomeVC {
    func getData() {
//
//        NetworkManager.shared.request(.home, modelType: HomeModel.self, success: { (model) in
//                //处理数据
//            self.homeData = model
//            self.reloadUI()
//            /// 因为布局原因，获取了home数据在加载新手指南
//            NetworkManager.shared.request(.theADs(advertCodes: [AdvertCode.D03]), modelType: [BaseADModel].self, success: { (model) in
//                //处理数据
//            self.beginnerData = model ?? []
//               
//                self.reloadUI()
//            }) { (_,_) in
////                self.mainTable.mj_header?.endRefreshing()
//            }
//            
//        }) { (_,_) in
////            self.mainTable.mj_header?.endRefreshing()
//        }
        
        
//        self.scrollView.mj_header?.endRefreshing()
//        NetworkManager.shared.request(AuthTarget.kingKong) { (result: NetworkResult<[AppIconItem]>) in
//            self.scrollView.mj_header?.endRefreshing()
//            do {
//                let response = try result.get()
//                self.categoriesView.categories = response
//                
//                self.categoriesView.snp.updateConstraints { make in
//                    make.height.equalTo(wScale(80))
//                }
//                self.categoriesView.collectionView.reloadData()
//                
//                
//            } catch {
//                
//            }
//            
//        }
    
        
        
    }
    
    func reloadUI() {
//        mainTable.mj_header?.endRefreshing()
//        mainTable.reloadData()
//        noticeView.model = homeData?.notice
    }
}
