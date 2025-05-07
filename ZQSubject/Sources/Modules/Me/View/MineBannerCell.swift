
import UIKit
import Then

class MineBannerCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func linkBtnClick() {
        
    }
    
    func setupUI() {
        
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLb)
    
        titleLb.text = "banner"
        
        iconIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        titleLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    lazy var iconIV: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
}

