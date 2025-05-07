
import UIKit
import Then

class UserQA2Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ iconName: String?,  with tilte: String, select:Bool = false) {
        if let iconName = iconName, iconName.count > 0 {
            self.iconImageView.image = UIImage(named: iconName)
        }
        self.titleLb.text = tilte
        self.titleLb.textColor = if select { .kTheme } else { .kText2 }
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = wScale(10)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLb)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(58))
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(10))
            
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(wScale(10))
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(wScale(-10))
        }
    }
    
    lazy var iconImageView: UIImageView = {
        UIImageView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
}
