
import UIKit
import Then

class StepItemView: UIView {
    enum Status {
        case pending
        case running
        case resolved
    }
    var stepStaus: StepStautsItemView.Status = .pending {
        didSet {
            updateStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStatus() {
        self.pendingView.isHidden = stepStaus != .pending
        self.runningView.isHidden = stepStaus != .running
        self.resolvedView.isHidden = stepStaus != .resolved
    }
     
    func setupUI() {
    
        addSubview(pendingView)
        addSubview(runningView)
        addSubview(resolvedView)
        pendingView.addSubview(indexLb)
        
        runningView.addSubview(pointBigView)
        runningView.addSubview(pointMidView)
        
        resolvedView.addSubview(pointView)
        self.pendingView.isHidden = true
        self.runningView.isHidden = true
        self.resolvedView.isHidden = true
        
        
        pendingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualTo(0)
        }
        
        indexLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.equalTo(0)
            make.width.height.equalTo(wScale(18))
        }
        
        runningView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualTo(0)
        }
        
        pointBigView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.equalTo(0)
            make.width.height.equalTo(wScale(22))
        }
        
        pointMidView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualTo(0)
            make.width.height.equalTo(wScale(10))
        }
        
        resolvedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualTo(0)
        }
        
        pointView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.left.equalTo(0)
            make.width.height.equalTo(wScale(18))
        }
    }
    
    lazy var pendingView: UIView = {
        return UIView()
    }()
    
    lazy var indexLb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(11, weight: .bold)
            $0.layer.cornerRadius = wScale(9)
            $0.backgroundColor = UIColor("#6D7A98")
            $0.textAlignment = .center
            $0.clipsToBounds = true
        }
    }()
    

    lazy var runningView: UIView = {
        return UIView()
    }()
    
    lazy var pointBigView: UIView = {
         UIView().then {
            $0.backgroundColor = .kTheme.withAlphaComponent(0.2)
            $0.layer.cornerRadius = wScale(11)
        }
    }()
    
    lazy var pointMidView: UIView = {
         UIView().then {
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(5)
        }
    }()
    
    lazy var resolvedView: UIView = {
        return UIView()
    }()
    
    lazy var pointView: UIView = {
         UIView().then {
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(9)
        }
    }()
}

