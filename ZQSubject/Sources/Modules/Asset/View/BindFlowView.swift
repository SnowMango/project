import UIKit
import Then


class BindFlowView: UIView {
    
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
        var title: String {
            switch self {
            case .account:
                "开户"
            case .system:
                "开通交易系统账户"
            case .strategy:
                "搭载策略"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        update()
    }
    var currentStep: BindFlowView.FlowStep = .account {
        didSet {
           update()
        }
    }
    
    private let steps:[BindFlowView.FlowStep] = [.account, .system, .strategy]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        switch currentStep {
        case .account:
            step1View.stepStaus = .running
            step2View.stepStaus = .pending
            step3View.stepStaus = .pending
        case .system:
            step1View.stepStaus = .resolved
            step2View.stepStaus = .running
            step3View.stepStaus = .pending
        case .strategy:
            step1View.stepStaus = .resolved
            step2View.stepStaus = .resolved
            step3View.stepStaus = .running
        }
    }

    // MARK: setup
    func setupUI() {
        addSubview(indexsView)
        indexsView.addSubview(step1View)
        indexsView.addSubview(step2View)
        indexsView.addSubview(step3View)

        indexsView.addSubview(line1View)
        indexsView.addSubview(line2View)
        
        addSubview(step1TitleLb)
        addSubview(step2TitleLb)
        addSubview(step3TitleLb)
        
        step1TitleLb.text = BindFlowView.FlowStep.account.title
        step2TitleLb.text = BindFlowView.FlowStep.system.title
        step3TitleLb.text = BindFlowView.FlowStep.strategy.title

    }
    
    func setupLayout() {
        indexsView.snp.makeConstraints { make in
            make.left.equalTo(wScale(35))
            make.right.equalTo(wScale(-35))
            make.top.equalTo(0)
        }
        step1View.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(wScale(22))
        }
        
        step2View.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualTo(0)
            make.width.equalTo(wScale(22))
        }
        
        step3View.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(0)
            make.width.equalTo(wScale(22))
        }
        
        line1View.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(step1View.snp.right).offset(16)
            make.right.equalTo(step2View.snp.left).offset(-16)
            make.height.equalTo(2)
        }
        
        line2View.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(step2View.snp.right).offset(16)
            make.right.equalTo(step3View.snp.left).offset(-16)
            make.height.equalTo(2)
        }
        
        step1TitleLb.snp.makeConstraints { make in
            make.centerX.equalTo(step1View)
            make.top.equalTo(indexsView.snp.bottom).offset(wScale(14))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        step2TitleLb.snp.makeConstraints { make in
            make.centerX.equalTo(step2View)
            make.top.equalTo(indexsView.snp.bottom).offset(wScale(14))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        step3TitleLb.snp.makeConstraints { make in
            make.centerX.equalTo(step3View)
            make.top.equalTo(indexsView.snp.bottom).offset(wScale(14))
            make.bottom.lessThanOrEqualTo(0)
        }
    }
    
   
    // MARK: lazy
    lazy var indexsView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white.withAlphaComponent(0.3)
            $0.layer.cornerRadius = wScale(5)
        }
    }()
    
    lazy var step1View: StepItemView = {
        return StepItemView().then {
            $0.indexLb.text = "1"
        }
    }()
    
    lazy var line1View: UIView = {
        return UIView().then {
            $0.backgroundColor = UIColor("#6D7A98")?.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 1
        }
    }()
    
    lazy var step2View: StepItemView = {
        return StepItemView().then {
            $0.indexLb.text = "2"
        }
    }()
    
    lazy var line2View: UIView = {
        return UIView().then {
            $0.backgroundColor = UIColor("#6D7A98")?.withAlphaComponent(0.2)
            $0.layer.cornerRadius = 1
        }
    }()
    
    lazy var step3View: StepItemView = {
        return StepItemView().then {
            $0.indexLb.text = "3"
        }
    }()
    
    lazy var step1TitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#444444")
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var step2TitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#444444")
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var step3TitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#444444")
            $0.font = .kScale(14, weight: .medium)
        }
    }()
}
