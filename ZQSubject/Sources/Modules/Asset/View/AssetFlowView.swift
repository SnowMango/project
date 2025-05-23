
import UIKit
import Then

class AssetFlowView: UIView {
    
    enum FlowStep {
        case account
        case system
        case strategy
        var path: String {
            switch self {
            case .account:
                "/bind/account"
            case .system:
                "/bind/system/account"
            case .strategy:
                "/build/strategy"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        update()
    }
    var currentStep: AssetFlowView.FlowStep = .account {
        didSet {
           update()
        }
    }
    
    private let steps:[String] = ["登录","证券开户","申请交易系统","策略搭建"]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        var highlightStep: String = ""
        applyBtn.isHidden = false
        switch currentStep {
        case .account:
            highlightStep = "证券开户"
            applyBtn.setTitle("去开户", for: .normal)
            bindBtn.setTitle("我已开户，去绑定", for: .normal)
        case .system:
            highlightStep = "申请交易系统"
            applyBtn.setTitle("去申请", for: .normal)
            bindBtn.setTitle("我已申请，去绑定", for: .normal)
        case .strategy:
            highlightStep = "策略搭建"
            applyBtn.isHidden = true
            bindBtn.setTitle("去搭载", for: .normal)
        }
        let index =  self.steps.firstIndex(of: highlightStep)
        for sub in self.stepStack.arrangedSubviews {
            if let label = sub as? UILabel {
                if let index = index, index + 100 == label.tag {
                    label.textColor = .kTheme
                }else{
                    label.textColor = .kText2
                }
            }
        }
    }
    
    @objc private func showApply() {
        guard let profile = AppManager.shared.profile else { return}
        if profile.needRisk() {
            AppLink.risk.routing()
            return
        }
        if profile.needRealName() {
            Router.shared.route("/commit/auth")
            return
        }
        if currentStep == .account {
            Router.shared.route("/open/account")
            return
        }
        if let url = profile.salesStaffInfo?.salespersonQrCode {
            let title = "截图微信扫码"
            let content = "添加客服，咨询交易账户相关"
            let alert = WindowAlert(title: title, content: content, url: url, actionTitle: "在线客服", alertType: .join)
            alert.doneCallBack = {
                AppLink.support.routing()
            }
            alert.show()
        }
    }
    
    @objc private func showBind() {
        guard let profile = AppManager.shared.profile else { return}
        if profile.needRisk() {
            AppLink.risk.routing()
            return
        }
        if profile.needRealName() {
            Router.shared.route("/commit/auth")
            return
        }
        self.showLoading()
        AppManager.shared.refreshUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(noticeRoute), name: UserProfileDidUpdateName, object: nil)
    }
    
    @objc func noticeRoute() {
        self.hideHud()
        NotificationCenter.default.removeObserver(self)
        guard let profile = AppManager.shared.profile else { return }
        if !profile.bindFundsAccount() {
            Router.shared.route(AssetFlowView.FlowStep.account.path)
            return
        }
        if !profile.bindQMTAccount() {
            Router.shared.route(AssetFlowView.FlowStep.system.path)
            return
        }
        if profile.strategySuccess() {
            AppLink.assetDetail.routing()
            return
        }
        Router.shared.route(AssetFlowView.FlowStep.strategy.path)
    }
    
    func makeStepLabel(_ title: String) -> UILabel {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText2
            $0.textAlignment = .center
            $0.text = title
        }
    }
    
    func makeSeparated() -> UIView{
        return UIImageView().then {
            $0.image = UIImage(named: "go_ahead")
        }
    }

    // MARK: setup
    func setupUI() {
        addSubview(backgourdIV)
        
        addSubview(stepView)
        stepView.addSubview(stepStack)
        
        addSubview(zqLabel)
        addSubview(safetyLabel)
        addSubview(descLb)
        
        addSubview(applyBtn)
        addSubview(bindBtn)
        
        zqLabel.text = "综合牌照券商"
        safetyLabel.text = "账号安全有保障"
        
        for (index, step) in steps.enumerated() {
            stepStack.addArrangedSubview(makeStepLabel(step).then({
                $0.tag = index + 100
            }))
            if index != steps.count - 1 {
                stepStack.addArrangedSubview(makeSeparated())
            }
        }
    }
    
    func setupLayout() {
        backgourdIV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(backgourdIV.snp.width).multipliedBy(812.0/375.0)
        }
        
        stepView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(70)
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(50))
        }
        
        stepStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(12))
        }
        
        zqLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(wScale(33))
            make.left.equalTo(wScale(48.5))
            make.height.equalTo(wScale(32))
        }
        safetyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(zqLabel)
            make.right.equalTo(wScale(-48.5))
            make.height.equalTo(wScale(32))
        }
        
        descLb.snp.makeConstraints { make in
            make.top.equalTo(zqLabel.snp.bottom).offset(wScale(18.5))
            make.centerX.equalToSuperview()
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(descLb.snp.bottom).offset(wScale(35))
            make.left.right.equalToSuperview().inset(wScale(43))
            make.height.equalTo(wScale(48))
        }
        
        bindBtn.snp.makeConstraints { make in
            make.top.equalTo(applyBtn.snp.bottom).offset(wScale(20))
            make.left.right.equalToSuperview().inset(wScale(43))
            make.height.equalTo(wScale(48))
        }
    }
    
   
    // MARK: lazy
    lazy var backgourdIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "asset_bg")
            $0.contentMode = .scaleAspectFill
        }
    }()
    
    lazy var stepView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white.withAlphaComponent(0.3)
            $0.layer.cornerRadius = wScale(5)
        }
    }()
    
    lazy var stepStack: UIStackView = {
        return UIStackView().then {
            $0.spacing = 13
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }()
    
    lazy var zqLabel: InsetLabel = {
        return InsetLabel().then {
            $0.contentInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
            $0.font = .kScale(16, weight: .medium)
            $0.textColor = .kTheme
            $0.layer.cornerRadius = wScale(16)
            $0.clipsToBounds = true
            $0.backgroundColor = .kTheme.withAlphaComponent(0.1)
        }
    }()
    
    lazy var safetyLabel: InsetLabel = {
        return InsetLabel().then {
            $0.contentInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
            $0.font = .kScale(16, weight: .medium)
            $0.textColor = .kTheme
            $0.backgroundColor = .kTheme.withAlphaComponent(0.1)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = wScale(16)
        }
    }()
    
    lazy var descLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = UIColor("5D708B")
            $0.textAlignment = .center
            $0.text = "全流程保护您的数据安全"
        }
    }()
    lazy var applyBtn: UIButton = {
        return UIButton().then {
            $0.titleLabel?.font =  .kScale(17, weight: .medium)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = wScale(24)
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(showApply), for: .touchUpInside)
        }
    }()
    
    lazy var bindBtn: UIButton = {
        return UIButton().then {
            $0.titleLabel?.font =  .kScale(17, weight: .medium)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = wScale(24)
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(showBind), for: .touchUpInside)
        }
    }()
    
}

