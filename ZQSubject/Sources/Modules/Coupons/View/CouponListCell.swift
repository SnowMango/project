
import UIKit
import Then
import Kingfisher

class CouponListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .white
        layer.cornerRadius = wScale(12)
        clipsToBounds = true
        addSubview(bgIV)
        bgIV.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0).inset(wScale(10))
        }
    }
    
    lazy var bgIV: UIImageView = {
        UIImageView().then {
            
            $0.image = UIImage(named: "coupon.bg")?.stretchableImage(withLeftCapWidth: 110, topCapHeight: 20)
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
        }
    }()
    
    lazy var nameLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
        }
    }()
    
    lazy var goBtn: UIButton = {
        UIButton().then {
            $0.layer.cornerRadius = wScale(27)/2.0
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.white, for: .disabled)
        }
    }()
}


