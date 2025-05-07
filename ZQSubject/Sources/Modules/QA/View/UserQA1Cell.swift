
import UIKit
import Then

class UserQA1Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ iconName: String?,  with tilte: String, desc: String, select:Bool = false) {
        if let iconName = iconName, iconName.count > 0 {
            self.iconImageView.image = UIImage(named: iconName)
        }
        self.titleLb.text = tilte
        self.descLb.text = desc
        self.selectIV.isHighlighted = select
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = wScale(10)
        
        contentView.addSubview(self.iconImageView)
        contentView.addSubview(textView)
        textView.addSubview(titleLb)
        textView.addSubview(descLb)
        contentView.addSubview(selectIV)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(40))
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(10))
            
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(wScale(10))
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(wScale(-10))
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.right.lessThanOrEqualTo(0)
        }
    
        descLb.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(titleLb.snp.bottom).offset(wScale(5))
            make.right.lessThanOrEqualTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        selectIV.snp.makeConstraints { make in
            make.right.equalTo(wScale(-10))
            make.top.equalTo(wScale(10))
        }
    }
    
    lazy var iconImageView: UIImageView = {
        UIImageView()
    }()
    
    lazy var textView: UIView = {
        UIView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(13)
            $0.numberOfLines = 0
        }
    }()
    
    lazy var selectIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "checkbox_normal")
            $0.highlightedImage = UIImage(named: "checkbox_select")
        }
    }()
}
