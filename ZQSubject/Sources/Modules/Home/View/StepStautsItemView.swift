
import UIKit
import Then

class StepStautsItemView: UIView {
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
    
    func add(runing text: String) {
//        self.runningBtn.setTitle(text, for: .normal)
        self.runningBtn.configuration?.attributedTitle = AttributedString(text, attributes: .init([.font: UIFont.kScale(9, weight: .medium),.foregroundColor: UIColor.white]))
        self.runningBtn.configuration =  self.runningBtn.configuration
    }
    
    func updateStatus() {
        statusIcon.isHighlighted = self.stepStaus == .resolved
        statusIcon.isHidden = self.stepStaus == .running
        runningBtn.isHidden = self.stepStaus != .running
    }
     
    func setupUI() {
        addSubview(self.titleLb)
        addSubview(self.runningBtn)
        addSubview(self.statusIcon)
        
        self.runningBtn.isHidden = true
        titleLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
        }
        runningBtn.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(8)
            make.height.equalTo(wScale(16))
            make.bottom.lessThanOrEqualTo(0)
        }
        statusIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(runningBtn.snp.centerY)
            make.bottom.lessThanOrEqualTo(0)
        }
    }
    
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(13, weight: .medium)
        }
    }()
    
    lazy var statusIcon: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "checkbox_normal")
            $0.highlightedImage = UIImage(named: "checkbox_select")
        }
    }()
    
    lazy var runningBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(16)/2.0
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
           
            $0.isUserInteractionEnabled = false
        }
    }()
}

