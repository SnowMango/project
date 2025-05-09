
import UIKit
import Then

class BindAccountNumberCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(self.iconImageView)
        contentView.addSubview(self.titleLb)
        contentView.addSubview(self.inputField)
        contentView.addSubview(self.descLb)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(22))
            make.left.equalTo(wScale(15))
            make.centerY.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(wScale(6))
        }
        inputField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(wScale(5))
            make.width.equalTo(wScale(130))
            make.height.equalTo(wScale(30))
        }
        descLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-18))
            make.left.equalTo(inputField.snp.right).offset(wScale(2))
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
    
    lazy var inputField: UITextField = {
        UITextField().then {
            $0.textColor = .kText2
            $0.font = .kScale(14)
            $0.textAlignment = .right
            $0.keyboardType = .numberPad
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(14)
            $0.textAlignment = .right
        }
    }()
}

extension BindAccountNumberCell: BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with value: String, placeholder: String?) {
        self.load(item: item, with: value, placeholder: placeholder, placeholderColor: nil)
    }
    func load(item: BindAccountVC.SectionItem, with value: String, placeholder: String?, placeholderColor: UIColor?) {
        
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        
        if value.count > 0 {
            self.inputField.text = value
        }
        self.descLb.text = placeholder
        if let color = placeholderColor {
            self.inputField.textColor = color
            self.descLb.textColor = color
        }
    }
    
    func load(item: BindAccountVC.SectionItem, with value: String) {
        self.load(item: item, with: value, placeholder: item.placeholder)
    }
}

extension BindAccountNumberCell: BuildStrategyCellProtocol {
    
    func load(item: BuildStrategyVC.SectionItem, with value: String) {
        self.load(item: item, with: value, placeholder: item.placeholder)
    }
    
    func load(item: BuildStrategyVC.SectionItem, with value: String, placeholder: String?) {
        self.load(item: item, with: value, placeholder: placeholder, placeholderColor: nil)
    }
    
    func load(item: BuildStrategyVC.SectionItem, with value: String, placeholder: String?, placeholderColor: UIColor?) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        self.inputField.text = value
        
        self.descLb.text = placeholder
        self.inputField.isSecureTextEntry = item.secureText
        if let color = placeholderColor {
            self.inputField.textColor = color
            self.descLb.textColor = color
        }
    }
}
