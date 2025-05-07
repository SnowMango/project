
import UIKit
import Then

class ServerItemView: SeparatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func upate(_ icon: String, title: String, desc: String, option: String) {
        self.iconImageView.image = UIImage(named: icon)
        self.titleLb.text = title
        self.descLb.text = desc
        self.optionBtn.setTitle(option, for: .normal)
    }
    
    func enableOption(_ enable: Bool) {
        self.optionBtn.isHidden = !enable
    }

    func setupUI() {
        addSubview(iconImageView)
        addSubview(titleLb)
        addSubview(descLb)
        addSubview(optionBtn)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(22))
            make.left.equalTo(wScale(15))
            make.centerY.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(wScale(12))
        }
        descLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        optionBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-15))
            make.width.equalTo(wScale(70))
            make.height.equalTo(wScale(29))
        }
    }
    
    lazy var iconImageView: UIImageView = {
        UIImageView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .init("#252525")
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(14)
        }
    }()
    
    lazy var optionBtn: UIButton = {
        UIButton().then {
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(29)/2.0
            $0.tintColor = .white
            $0.titleLabel?.font = .kScale(12, weight: .medium)
        }
    }()
}
