
import UIKit
import Then

class ApplyTransactionStatusView: UIView {
    var currentStep: AssetFlowView.FlowStep = .account
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func signupClick() {
        if currentStep == .strategy {
            self.window?.showLoading()
            AppManager.shared.refreshUserInfo()
            NotificationCenter.default.addObserver(self, selector: #selector(noticeRoute), name: UserProfileDidUpdateName, object: nil)
            return
//            Router.shared.route(currentStep.path)
        }
        guard let profile = AppManager.shared.profile else { return }
        
        if profile.needRisk() {
            JumpManager.jumpToWeb(AppLink.risk.path)
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
                JumpManager.jumpToWeb(AppLink.support.path)
            }
            alert.show()
        }
    }
    
    @objc func bindClick() {
        guard let profile = AppManager.shared.profile else { return }
        if profile.needRisk() {
            JumpManager.jumpToWeb(AppLink.risk.path)
            return
        }
        if profile.needRealName() {
            Router.shared.route("/commit/auth")
            return
        }
        self.window?.showLoading()
        AppManager.shared.refreshUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(noticeRoute), name: UserProfileDidUpdateName, object: nil)
    }
    
    @objc func noticeRoute() {
        self.window?.hideHud()
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
            JumpManager.jumpToWeb(AppLink.assetDetail.path)
            return
        }
        Router.shared.route(AssetFlowView.FlowStep.strategy.path)
    }

    func reloadData() {
        if let profile = AppManager.shared.profile {
            if let _ = profile.tradingAccount  {
                currentStep = .strategy
            } else if let _ = profile.fundAccount {
                currentStep = .system
            }else {
                currentStep = .account
            }
            if profile.strategySuccess() {
                self.isHidden = true
            }else{
                self.isHidden = false
            }
        }
    
        switch currentStep {
        case .account:
            bindBtn.isHidden = false
            stepAccount.stepStaus = .running
            stepApply.stepStaus = .pending
            stepStrategy.stepStaus = .pending
            signupBtn.setTitle("去开户", for: .normal)
            bindBtn.setTitle("我已开户，去绑定", for: .normal)
            break
        case .system:
            stepAccount.stepStaus = .resolved
            stepApply.stepStaus = .pending
            stepStrategy.stepStaus = .pending
            bindBtn.isHidden = false
            signupBtn.setTitle("去申请", for: .normal)
            bindBtn.setTitle("我已开户，去绑定", for: .normal)
            break
        case .strategy:
            bindBtn.isHidden = true
            stepAccount.stepStaus = .resolved
            stepApply.stepStaus = .resolved
            stepStrategy.stepStaus = .pending
            signupBtn.setTitle("去搭载", for: .normal)
            break
        }
    }
    
    //MARK: setup
    func setupUI() {
        self.titleLb.text = "4步搞定交易策略"
        
        addSubview(titleLb)
        addSubview(cardView)
        cardView.addSubview(stepStack)
        stepStack.addArrangedSubview(stepLogin)
        stepStack.addArrangedSubview(makeStepSeparator())
        stepStack.addArrangedSubview(stepAccount)
        stepStack.addArrangedSubview(makeStepSeparator())
        stepStack.addArrangedSubview(stepApply)
        stepStack.addArrangedSubview(makeStepSeparator())
        stepStack.addArrangedSubview(stepStrategy)
        
        cardView.addSubview(btnStack)
    
        btnStack.addArrangedSubview(signupBtn)
        btnStack.addArrangedSubview(bindBtn)
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(12)
            make.right.greaterThanOrEqualTo(0)
        }
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.height.equalTo(wScale(120))
            make.bottom.lessThanOrEqualTo(0)
        }
        stepStack.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(wScale(18))
            make.right.equalTo(wScale(-18))
        }
        
        btnStack.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(wScale(16))
            make.top.equalTo(stepStack.snp.bottom).offset(wScale(18))

            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(wScale(-18))
        }
        
        signupBtn.snp.makeConstraints { make in
            make.width.equalTo(wScale(152))
            make.height.equalTo(wScale(34))
        }
        
        bindBtn.snp.makeConstraints { make in
            make.width.equalTo(wScale(152))
            make.height.equalTo(wScale(34))
        }
    }
    
    func makeStepSeparator() -> UIView {
        UIView().then {
            let iv = UIImageView()
            iv.image = UIImage(named: "step.next.arrow")
            $0.addSubview(iv)
            iv.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: wScale(3), left: 0, bottom: wScale(3), right: 0))
            }
        }
    }
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
        }
    }()
    /// 整个背景卡片
    private let cardView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var stepStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 12
            $0.distribution = .equalSpacing
            $0.alignment = .top
            $0.axis = .horizontal
        }
    }()
    lazy var stepLogin: StepStautsItemView = {
        return StepStautsItemView().then {
            $0.titleLb.text = "登录"
            $0.stepStaus = .resolved
        }
    }()
    
    lazy var stepAccount: StepStautsItemView = {
        return StepStautsItemView().then {
            $0.titleLb.text = "证券开户"
            $0.add(runing: "开户中")
            $0.stepStaus = .running
        }
    }()
    
    lazy var stepApply: StepStautsItemView = {
        return StepStautsItemView().then {
            $0.titleLb.text = "申请交易系统"
        }
    }()
    
    lazy var stepStrategy: StepStautsItemView = {
        return StepStautsItemView().then {
            $0.titleLb.text = "策略搭建"
        }
    }()
    
    lazy var btnStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 14
            $0.distribution = .fillEqually
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }()
    
    lazy var signupBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitle("去开户", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(6)
            $0.titleLabel?.font = .kScale(12, weight: .medium)
            $0.addTarget(self, action: #selector(signupClick), for: .touchUpInside)
        }
    }()
    
    lazy var bindBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitle("我已开户，去绑定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kAlert
            $0.layer.cornerRadius = wScale(6)
            $0.titleLabel?.font = .kScale(12, weight: .medium)
            $0.addTarget(self, action: #selector(bindClick), for: .touchUpInside)
        }
    }()
}

