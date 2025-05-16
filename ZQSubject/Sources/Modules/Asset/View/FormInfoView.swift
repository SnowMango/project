
import UIKit
import Then

class FormInfoView: SeparatorView {
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
    
   
    func setupUI() {
        addSubview(requiredLb)
        addSubview(titleLb)
        addSubview(descLb)

        requiredLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(16))
        }

        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(requiredLb.snp.right)
        }
        
        descLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-18))
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
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
}




