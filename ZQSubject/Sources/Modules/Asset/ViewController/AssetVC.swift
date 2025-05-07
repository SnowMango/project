
import UIKit
import Then

class AssetVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBackBtn = true
        fd_prefersNavigationBarHidden = true
        initUI()
   
        NotificationCenter.default.addObserver(self, selector: #selector(updataUserProfile), name: UserProfileDidUpdateName, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        AppManager.shared.refreshUserInfo()
    }
    
    @objc func updataUserProfile() {
        self.reloadData()
    }

    @objc func checkBtnClick() {
        JumpManager.jumpToWeb(AppLink.assetDetail.path)
    }
    
    func reloadData(){
        guard let profile = AppManager.shared.profile else { return }

        if let _ = profile.tradingAccount {
            flowView.currentStep = .strategy
        } else if let _ = profile.fundAccount {
            flowView.currentStep = .system
        } else {
            flowView.currentStep = .account
        }
        
        if profile.strategySuccess() {
            flowView.isHidden = true
        }else{
            flowView.isHidden = false
        }
    }
    
    private func initUI() {
       
        let bgImgv = UIImageView(image: UIImage(named:"asset.page.bg"))
        view.addSubview(bgImgv)
        bgImgv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(bgImgv.snp.width).multipliedBy(812.0/375.0)
        }
        
        let chakanBtn = UIButton()
        chakanBtn.setTitle("查看收益情况", for: .normal)
        chakanBtn.setTitleColor(.white, for: .normal)
        chakanBtn.titleLabel?.font = .kScale(17, weight: .medium)
        chakanBtn.layer.cornerRadius = wScale(24)
        chakanBtn.backgroundColor = .kTheme
        chakanBtn.addTarget(self, action: #selector(checkBtnClick), for: .touchUpInside)
        view.addSubview(chakanBtn)
        chakanBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-wScale(175))
            make.left.right.equalToSuperview().inset(wScale(43))
            make.height.equalTo(wScale(48))
        }
        view.addSubview(titleLb)
//        view.addSubview(shareBtn)
//        view.addSubview(scrollView)
        view.addSubview(flowView)
        
        flowView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
//        scrollView.addSubview(contentView)
//        contentView.addSubview(backgourdView)
//        contentView.addSubview(sectionsStack)
//        
//        sectionsStack.addArrangedSubview(totalView)
//        sectionsStack.addArrangedSubview(strategyStatusView)
//        sectionsStack.addArrangedSubview(warehouseView)
//        sectionsStack.addArrangedSubview(gainView)
//        
//        scrollView.snp.makeConstraints { make in
//            make.left.right.bottom.equalTo(0)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
//        }
        titleLb.snp.makeConstraints { make in
//            make.left.equalTo(wScale(25))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
//        shareBtn.snp.makeConstraints { make in
//            make.right.equalTo(wScale(-15))
//            make.bottom.equalTo(titleLb)
//        }
//        
//        contentView.snp.makeConstraints { make in
//            make.left.right.top.bottom.equalTo(0)
//            make.centerX.equalToSuperview()
//        }
//        backgourdView.snp.makeConstraints { make in
//            make.left.right.top.equalTo(0)
//            make.bottom.equalTo(contentView.snp.top).offset(wScale(420))
//        }
//        
//        sectionsStack.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets.init(top: wScale(5), left: wScale(14), bottom: wScale(18), right: wScale(14)))
//        }
//        
//        totalView.snp.makeConstraints { make in
//            make.left.equalTo(0)
//            make.height.equalTo(wScale(343))
//        }
//        strategyStatusView.snp.makeConstraints { make in
//            make.left.equalTo(0)
//            make.height.equalTo(wScale(85))
//        }
//        warehouseView.snp.makeConstraints { make in
//            make.left.equalTo(0)
//            make.height.equalTo(wScale(173))
//        }
//        gainView.snp.makeConstraints { make in
//            make.left.equalTo(0)
//            make.height.equalTo(wScale(300))
//        }
    }
    
    lazy var flowView: AssetFlowView = {
        AssetFlowView().then {
            $0.currentStep = .account
        }
    }()
    
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(16, weight: .medium)
            $0.textColor = .kText2
            $0.text = "资产"
        }
    }()
    
    lazy var shareBtn: UIButton = {
        return UIButton().then {
            $0.titleLabel?.font =  .kScale(14, weight: .medium)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("一键晒收益", for: .normal)
        }
    }()
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
        }
    }()

    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .kBackGround
        }
    }()
    lazy var backgourdView: UIView = {
        return UIView().then {
            $0.backgroundColor = .kTheme
        }
    }()
    
    lazy var sectionsStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = wScale(18)
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var totalView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    lazy var strategyStatusView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var warehouseView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var gainView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
}
