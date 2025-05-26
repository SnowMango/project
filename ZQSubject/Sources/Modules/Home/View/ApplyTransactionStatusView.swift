
import UIKit
import Then
import RxCocoa
import RxSwift

class ApplyTransactionStatusView: UIView {
    var disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeRx()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        guard let profile = AppManager.shared.profile else { return }
        guard let board = profile.userServerStatusBoard else {
            self.isHidden = true
            return
        }
        self.isHidden = false
        
        let progress: CGFloat = CGFloat(Int(board.loadingProgress ?? "0") ?? 0)
        update(progress: max(min(1, progress/100.0), 0))
        step1Lb.text = nil
        step2Lb.text = nil
        step3Lb.text = nil
        if let step = board.steps(), step.count >= 3 {
            step1Lb.text = step[0]
            step2Lb.text = step[1]
            step3Lb.text = step[2]
        }
        
        accountView.isHidden = progress > 50
        accountView.load(with: board)
        strategyStatusView.isHidden = !accountView.isHidden
        strategyStatusView.load(with: board)
    }
    
    func update(progress: CGFloat) {
        progressLb.text = "\(Int(progress*100))"
        slider.progress = progress
        point1View.backgroundColor = abs(progress) > 0.01 ? UIColor("#FFCF0F"):.white
        point2View.backgroundColor = progress > 0.49 ? UIColor("#FFCF0F"):.white
        point3View.backgroundColor = abs(progress - 1) < 0.01 ? UIColor("#FFCF0F"):.white
    }
    
    func makeRx() {
        accountView.doneBtn.rx.tap.subscribe(onNext: { _ in
            guard let profile = AppManager.shared.profile, let board = profile.userServerStatusBoard else { return }
            if profile.needRealName() {
                Router.shared.route("/commit/auth")
                return
            }
            if let path = board.jumpLinkAddress {
                Router.shared.route(path)
            }
        }).disposed(by: disposeBag)
        
        accountView.goBtn.rx.tap.subscribe(onNext: { _ in
            guard let profile = AppManager.shared.profile, let board = profile.userServerStatusBoard else { return }
            if let path = board.buttonLinkAddress {
                Router.shared.route(path)
            }
        }).disposed(by: disposeBag)
        strategyStatusView.goBtn.rx.tap.subscribe(onNext: {
            guard let profile = AppManager.shared.profile, let board = profile.userServerStatusBoard else { return }
            
            if let path = board.buttonLinkAddress {
                Router.shared.route(path)
            }
        }).disposed(by: disposeBag)
        
    }
    
    
    //MARK: setup
    func setupUI() {
        self.titleLb.text = "服务看板"
        
        addSubview(titleLb)
        addSubview(cardView)
       
        cardView.addSubview(bgIV)
        cardView.addSubview(progressView)
        cardView.addSubview(stepsStack)
        
        progressView.addSubview(progressBGIV)
        progressView.addSubview(progressLb)
        progressView.addSubview(persentLb)
        progressView.addSubview(doneLb)
        progressView.addSubview(slider)
        
        progressView.addSubview(point1View)
        progressView.addSubview(point2View)
        progressView.addSubview(point3View)
        
        progressView.addSubview(step1Lb)
        progressView.addSubview(step2Lb)
        progressView.addSubview(step3Lb)
        
        cardView.addSubview(stepsStack)
        stepsStack.addArrangedSubview(accountView)
        stepsStack.addArrangedSubview(strategyStatusView)
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(12)
            make.right.lessThanOrEqualTo(0)
        }
        
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(wScale(94))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        stepsStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        progressBGIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        progressLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.top.equalTo(wScale(10))
        }
        
        persentLb.snp.makeConstraints { make in
            make.left.equalTo(progressLb.snp.right)
            make.lastBaseline.equalTo(progressLb)
        }
        
        doneLb.snp.makeConstraints { make in
            make.left.equalTo(persentLb.snp.right).offset(6)
            make.centerY.equalTo(progressLb)
            make.width.equalTo(wScale(42))
            make.height.equalTo(wScale(16))
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(progressLb.snp.bottom).offset(wScale(12))
            make.left.equalTo(wScale(16))
            make.right.equalTo(wScale(-16))
            make.height.equalTo(2)
        }
        
        point1View.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.centerY.equalTo(slider)
            make.height.width.equalTo(wScale(6))
        }
        
        point2View.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(slider)
            make.height.width.equalTo(wScale(6))
        }
        
        point3View.snp.makeConstraints { make in
            make.right.equalTo(wScale(-16))
            make.centerY.equalTo(slider)
            make.height.width.equalTo(wScale(6))
        }
        
        step1Lb.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.top.equalTo(slider.snp.bottom).offset(wScale(12))
        }
        
        step2Lb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(step1Lb)
        }
        
        step3Lb.snp.makeConstraints { make in
            make.right.equalTo(wScale(-16))
            make.centerY.equalTo(step1Lb)
        }
        
        accountView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        strategyStatusView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
    }
    
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    /// 整个背景卡片
    private let cardView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
            $0.clipsToBounds = true
        }
    }()
    
    lazy var progressView: UIView = {
        UIView()
    }()
    
    lazy var progressBGIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "home.strategy.bg1")
        }
    }()
    
    lazy var progressLb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(27, weight: .bold)
        }
    }()
    
    lazy var persentLb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(18, weight: .bold)
            $0.text = "%"
        }
    }()
    
    lazy var doneLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kTheme
            $0.font = .kScale(9, weight: .bold)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
            $0.textAlignment = .center
            $0.text = "已完成"
            $0.clipsToBounds = true
        }
    }()
    
    lazy var slider: StrategySlider = {
        StrategySlider()
    }()
    
    lazy var point1View: UIView = {
        UIView().then {
            $0.backgroundColor = UIColor("#FFCF0F")
            $0.layer.cornerRadius = wScale(3)
        }
    }()
    
    lazy var point2View: UIView = {
        UIView().then {
            $0.backgroundColor = UIColor("#FFCF0F")
            $0.layer.cornerRadius = wScale(3)
        }
    }()
    
    lazy var point3View: UIView = {
        UIView().then {
            $0.backgroundColor = UIColor("#FFCF0F")
            $0.layer.cornerRadius = wScale(3)
        }
    }()
    
    lazy var step1Lb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(13, weight: .medium)
        }
    }()
    
    lazy var step2Lb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(13, weight: .medium)
        }
    }()
    
    lazy var step3Lb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(13, weight: .medium)
        }
    }()
    
    lazy var bgIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "home.strategy.bg2")
        }
    }()
     
    lazy var stepsStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var accountView: HomeAccountView = {
        HomeAccountView().then {
            $0.isHidden = true
        }
    }()
    
    lazy var strategyStatusView: HomeStrategyView = {
        HomeStrategyView().then {
            $0.isHidden = true
        }
    }()

    
}

