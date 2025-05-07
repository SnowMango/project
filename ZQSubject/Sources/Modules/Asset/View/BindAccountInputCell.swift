
import UIKit
import Then

class BindAccountInputCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeSecureState(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.inputField.isSecureTextEntry = btn.isSelected
    }
    
    func makeSecureBtn() -> UIButton {
        UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40)).then {
            $0.setImage(UIImage(named: "secure.eye.open"), for: .normal)
            $0.setImage(UIImage(named: "secure.eye.close"), for: .selected)
            $0.isSelected = true
            $0.addTarget(self, action: #selector(changeSecureState), for: .touchDown)
        }
    }
    
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLb)
        contentView.addSubview(inputField)
        inputField.rightView = makeSecureBtn()
        inputField.rightViewMode = .never
        
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
            make.left.equalTo(wScale(150))
            make.right.equalTo(wScale(-15))
            make.height.equalTo(wScale(30))
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
        }
    }()
}

extension BindAccountInputCell: BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        if value.count > 0 {
            self.inputField.text = value
        }
        self.inputField.attributedPlaceholder = NSAttributedString(string: item.placeholder, attributes: [.font:UIFont.kScale(14), .foregroundColor:UIColor.kText1])
    }
}

extension BindAccountInputCell: BuildStrategyCellProtocol {
    func load(item: BuildStrategyVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        
        self.inputField.text = value
        self.inputField.attributedPlaceholder = NSAttributedString(string: item.placeholder, attributes: [.font:UIFont.kScale(14), .foregroundColor:UIColor.kText1])
        self.inputField.isSecureTextEntry = item.secureText
        if item.secureText {
            inputField.rightViewMode = .always
        }else{
            inputField.rightViewMode = .never
        }
    }
}
