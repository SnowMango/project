
import UIKit
import Then
import Kingfisher

class MineFeatureCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ iconName: String?,  with tilte: String?) {
        if let iconName = iconName {
            self.iconImageView.kf.setImage(with: URL(string: iconName))
        }
        self.titleLb.text = tilte
    }
    
    func setupUI() {
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.titleLb)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(20))
            make.top.equalTo(wScale(16))
            make.centerX.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.top.equalTo(iconImageView.snp.bottom).offset(wScale(10))
        }
    }
    
    lazy var iconImageView: UIImageView = {
        UIImageView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
        }
    }()
}

