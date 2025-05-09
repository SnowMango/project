
import UIKit
import Then

class BuildStrategyFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(buildBtn)
        
        addSubview(freeInfoView)
        freeInfoView.addSubview(freeBGIV)
        freeInfoView.addSubview(freeContentLb)
        
        buildBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
        
        freeInfoView.snp.makeConstraints { make in
            make.right.equalTo(wScale(-13))
            make.bottom.equalTo(buildBtn.snp.top).offset(10)
        }
        freeBGIV.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(0)
        }
        freeContentLb.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualTo(0)
        }
    }
    
    lazy var freeInfoView: UIView = {
        UIView()
    }()
    
    lazy var freeBGIV: UIImageView = {
        UIImageView().then {
            if let bg = UIImage(named: "tiyan.qipao") {
                $0.image = bg.resizableImage(withCapInsets: .init(top: 10, left: 40, bottom: 10, right: 40), resizingMode: .stretch)
            }
        }
    }()
    lazy var freeContentLb: UILabel = {
        UILabel().then {
            $0.textColor = .kAlert3
            $0.textAlignment = .center
            $0.text = "体验活动专属福利"
            $0.font = .kScale(13,weight: .bold)
        }
    }()
    
    lazy var buildBtn = {
        UIButton(type: .custom).then {
            $0.setTitle("确认搭载", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
//            $0.addTarget(self, action: #selector(buildClick), for: .touchUpInside)
        }
    }()

}
