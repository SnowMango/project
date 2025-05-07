
import UIKit
import Then

class UserQA3Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(_ tilte: String, select:Bool = false) {
        self.titleLb.text = tilte
        self.selectIV.isHighlighted = select
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = wScale(10)
        
        contentView.addSubview(titleLb)
        contentView.addSubview(selectIV)
    
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(25))
            make.centerY.equalToSuperview()
        }
    
        selectIV.snp.makeConstraints { make in
            make.right.equalTo(wScale(-20))
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    
    lazy var selectIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "checkbox_normal")
            $0.highlightedImage = UIImage(named: "checkbox_select")
        }
    }()
}
