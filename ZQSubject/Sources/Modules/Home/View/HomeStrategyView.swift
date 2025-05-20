
import UIKit
import Then

class HomeStrategyView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: setup
    func setupUI() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(statusView)
        
        statusView.addSubview(statusIconIV)
        statusView.addSubview(statusMessageLb)
        
        contentStack.addArrangedSubview(infoView)
        infoView.addSubview(doneBtn)
        
        contentStack.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        statusView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.height.equalTo(wScale(75))
        }
        
        statusIconIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(statusMessageLb.snp.left).offset(wScale(-10))
        }
        
        statusMessageLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(wScale(20))
        }
        
        infoView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }

        doneBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.right.equalTo(wScale(-12))
            make.top.equalTo(0)
            make.height.equalTo(wScale(44))
            make.bottom.lessThanOrEqualTo(wScale(-20))
        }
    }
    
    lazy var contentStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 0
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var statusView: UIView = {
        UIView()
    }()

    lazy var statusIconIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "success.normal")
            //alert.success alert.error alert.info
        }
    }()
    
    
    lazy var statusMessageLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.text = "策略搭载审核失败，请重新提交"
        }
    }()
    
    
    lazy var infoView: UIView = {
        UIView()
    }()
    
    lazy var doneBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(8)
            $0.titleLabel?.font = .kScale(16, weight: .medium)
            $0.setTitle("去搭载", for: .normal)
//            $0.addTarget(self, action: #selector(bindClick), for: .touchUpInside)
        }
    }()
    

}

