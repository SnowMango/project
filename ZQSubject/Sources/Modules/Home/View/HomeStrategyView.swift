
import UIKit
import Then
import Kingfisher

class HomeStrategyView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(with board: StatusBoard) {
        statusIconIV.kf.setImage(with: URL(string: board.describeIcon ?? ""))
        statusMessageLb.text = board.describeMessage
        goBtn.setTitle(board.buttonText, for: .normal)
        infoView.isHidden = board.buttonText == nil
    }
    
    //MARK: setup
    func setupUI() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(statusView)
        
        statusView.addSubview(statusIconIV)
        statusView.addSubview(statusMessageLb)
        
        contentStack.addArrangedSubview(infoView)
        infoView.addSubview(goBtn)
        
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

        goBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.right.equalTo(wScale(-12))
            make.top.equalTo(0)
            make.height.equalTo(wScale(44))
            make.bottom.equalTo(wScale(-20))
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
        }
    }()
    
    
    lazy var statusMessageLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var infoView: UIView = {
        UIView()
    }()
    
    lazy var goBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(8)
            $0.titleLabel?.font = .kScale(16, weight: .medium)
        }
    }()
    

}

