
import UIKit
import Then

class BindAccountInfoCell: RadiusCollectionCell {
    
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
        descLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-18))
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
            $0.textColor = .kText2
            $0.font = .kScale(14)
        }
    }()
}

extension BindAccountInfoCell: BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        self.descLb.text = "\(value) \(item.placeholder)"
    }
}

extension BindAccountInfoCell: BuildStrategyCellProtocol {
    func load(item: BuildStrategyVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
        self.descLb.text = "\(value) \(item.placeholder)"
    }
}


