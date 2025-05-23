
import UIKit
import Then

class MineAccountView: RadiusView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func linkBtnClick() {
        guard let profile = AppManager.shared.profile else { return}
        if profile.needRisk() {
            AppLink.risk.routing()
            return
        }
        if profile.needRealName() {
            Router.shared.route("/commit/auth")
            return
        }
        Router.shared.route("/open/account")
    }
    
    func setupUI() {
        addSubview(titleLb)
        addSubview(descLb)
        addSubview(linkBtn)
        titleLb.text = "完成交易前准备"
        descLb.text = "绑定银行卡、实名认证"
        linkBtn.setTitle("立即开户", for: .normal)
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.centerY.equalToSuperview().offset(wScale(-14))
        }
        
        descLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.centerY.equalToSuperview().offset(wScale(12))
        }
        
        linkBtn.snp.makeConstraints { make in
            make.right.equalTo(wScale(-12))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(98))
            make.height.equalTo(wScale(29))
        }
    }
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var linkBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.titleLabel?.font = .kScale(12, weight: .medium)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(29)/2.0
            $0.addTarget(self, action: #selector(linkBtnClick), for: .touchUpInside)
        }
    }()
}
