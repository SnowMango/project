
import UIKit
import Then

class FormInputView: SeparatorView {
    
    var isRequired: Bool = false {
        didSet {
            updateRequired()
        }
    }
    
    var requiredTag: String = "*" {
        didSet {
            updateRequired()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRequired() {
        if !isRequired {
            self.requiredLb.text = nil
            return
        }
        self.requiredLb.text = requiredTag
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
        addSubview(requiredLb)
        addSubview(titleLb)
        addSubview(inputField)
        
        inputField.rightView = makeSecureBtn()
        inputField.rightViewMode = .never
        
        requiredLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(16))
        }

        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(requiredLb.snp.right)
        }
        
        inputField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(wScale(5))
            make.left.equalTo(wScale(150))
            make.right.equalTo(wScale(-15))
            make.height.equalTo(wScale(30))
        }
    }
    
    lazy var requiredLb: UILabel = {
        UILabel().then {
            $0.textColor = .init("#E42D3C")
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var inputField: UITextField = {
        UITextField().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
            $0.textAlignment = .right
        }
    }()
}

