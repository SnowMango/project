
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
        buildBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
    }
    
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
