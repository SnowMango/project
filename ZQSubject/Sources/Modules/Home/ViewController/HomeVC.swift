import UIKit
import MarqueeLabel
import MJRefresh
import Then
import RxCocoa

class HomeVC: BaseViewController {
    
    var hasUnread: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航栏
        hiddenNavigationBarWhenShow = true
        setupUI()
        
        msgBtn.rx.tap.subscribe(onNext: { _ in
            Router.shared.route("/message")
        }).disposed(by: disposeBag)
        
        contactUsBtn.rx.tap.subscribe(onNext: { _ in
            AppLink.support.routing()
        }).disposed(by: disposeBag)
       
        NotificationCenter.default.rx.notification(UserProfileDidUpdateName).subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        AppManager.shared.startTask()
        AppManager.shared.loginInit()
        AppManager.shared.refreshKingkong {[weak self] in
            self?.reloadData()
        }
        AppManager.shared.reloadKingkong()
        updateUnread()
        reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppManager.shared.refreshUserInfo()
        requestStroy()
        checkUnread()
        reloadData()
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
            self.categoriesView.categories = items
            self.categoriesView.isHidden = false
    
        } else {
            self.categoriesView.categories = []
            self.categoriesView.isHidden = true
        }
        transactionStatusView.reloadData()

    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(levitate)
       
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(contactUsBtn)
        contentView.addSubview(msgBtn)
        contentView.addSubview(redPoint)
        
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
            make.width.height.equalTo(wScale(68))
        }
        
        noticeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(40)
            make.height.equalTo(wScale(22))
        }
        
        contactUsBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(44)
            make.width.equalTo(30)
        }
        
        msgBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(30)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(contactUsBtn.snp.left).offset(2)
        }
        
        redPoint.snp.makeConstraints { make in
            make.left.equalTo(msgBtn.snp.centerX).offset(1)
            make.top.equalTo(msgBtn).offset(15)
            make.width.height.equalTo(6)
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
            make.bottom.lessThanOrEqualTo(wScale(-12))
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
            $0.setImage(UIImage(named: "contact"), for: .normal)
        }
    }()
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
            $0.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
                self?.getData()
            })
//            $0.mj_header?.mj_h += kStatusBarH()
//            $0.mj_header?.ignoredScrollViewContentInsetTop -= kStatusBarH()*0.5
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
        }
    }()
    
    lazy var msgBtn: UIButton = {
        UIButton().then {
            $0.setImage(UIImage(named: "message"), for: .normal)
        }
    }()
    
    private lazy var redPoint: UIView = {
        UIView().then {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 3
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
            $0.distribution = .fill
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
        return UserMessageView().then { $0.isHidden = true }
    }()
    
    lazy var  levitate:LevitateView  = {
        return LevitateView().then { $0.isHidden = true }
    }()
}

extension HomeVC {
    func getData() {
       
    }
    
    func requestStroy() {
        NetworkManager.shared.request(AuthTarget.stroy) { (result: NetworkResult<[UserMessageModel]>) in
            do {
                let response = try result.get()
                self.userMessageView.messages = response
                self.userMessageView.reloadData()
            
            } catch {
                
            }
        }
    }
    
    func reloadUI() {
//        mainTable.mj_header?.endRefreshing()
//        mainTable.reloadData()
//        noticeView.model = homeData?.notice
    }
}

extension HomeVC {
    
    private func checkUnread() {
        NetworkManager.shared.request(AuthTarget.unreadMsg) { (result: JSONResult) in
            do {
                let response = try result.get()
                let unreadCount = response["unreadCount"].intValue
                let _ = response["readCount"].intValue
                self.hasUnread = unreadCount > 0
                self.updateUnread()
            } catch {
                
            }
        }
    }
    
    func updateUnread() {
        self.redPoint.isHidden = !self.hasUnread
    }
}
