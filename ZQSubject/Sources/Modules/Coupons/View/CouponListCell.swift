
import UIKit
import Then
import Kingfisher

class CouponListCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        separatorStyle = .none
        mock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(with coupon: Coupon) {
        if coupon.isPriceCoupon {
            titleLb.attributedText = coupon.discountValue.highlightKeyword("￥", color: UIColor(0xFD3A3A), font: .kScale(14, weight: .medium)).add(.kern, value: -2)
            nameLb.text = "满\(Int(coupon.thresholdAmount ?? 0))减\(Int(coupon.price ?? 0))"
           
        } else {
            nameLb.text = "限时免费体验"
            titleLb.attributedText = coupon.discountValue.highlightKeyword("天", color: UIColor(0xFD3A3A), font: .kScale(14, weight: .medium)).add(.kern, value: -2)
        }
       
        descLb.text = (coupon.validStartTime ?? "--") + "-" + (coupon.validEndTime ?? "--")
        switch coupon.status {
        case .unused:
            goBtn.isEnabled = true
            goBtn.setTitle("立即使用", for: .normal)
            goBtn.backgroundColor = UIColor("#F52D24")
        case .used:
            goBtn.isEnabled = false
            goBtn.setTitle("已使用", for: .normal)
            goBtn.backgroundColor = UIColor("#EDE8E6")
        case .expired:
            goBtn.isEnabled = false
            goBtn.setTitle("已过期", for: .normal)
            goBtn.backgroundColor = UIColor("#EDE8E6")
        }
       
       
    }
    
    func mock() {
        titleLb.attributedText = "￥50".highlightKeyword("￥", color: UIColor(0xFD3A3A), font: .kScale(14, weight: .medium)).add(.kern, value: -2)
        
        nameLb.text = "满10000减50"
        descLb.text = "2025.04.01-2025.04.30"
        
        
        goBtn.backgroundColor = UIColor("#F52D24")
    }
    
    func makeUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(rangeView)
        rangeView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0).inset(wScale(10))
            make.height.equalTo(wScale(90))
        }

        rangeView.addSubview(bgIV)
        bgIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        rangeView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(5))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(90))
        }
        
        rangeView.addSubview(nameLb)
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(110))
            make.bottom.equalTo(rangeView.snp.centerY)
        }
        rangeView.addSubview(descLb)
        descLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(110))
            make.top.equalTo(rangeView.snp.centerY).offset(wScale(6))
        }
        
        rangeView.addSubview(goBtn)
        goBtn.snp.makeConstraints { make in
            make.right.equalTo(wScale(-6))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(77))
            make.height.equalTo(wScale(27))
        }
    }
    
    lazy var rangeView: UIView = {
        UIView()
    }()
    
    lazy var bgIV: UIImageView = {
        UIImageView().then {
//            $0.image = UIImage(named: "coupon.bg")?.stretchableImage(withLeftCapWidth: 110, topCapHeight: 20)
            $0.image = UIImage(named: "coupon.bg")
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#F52D24")
            $0.font = .systemFont(ofSize: 36, weight: .bold)
            $0.minimumScaleFactor = 0.75
            $0.textAlignment = .center
        }
    }()
    
    lazy var nameLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#FD3A3A")
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#B9A3A3")
            $0.font = .kScale(11, weight: .regular)
        }
    }()
    
    lazy var goBtn: UIButton = {
        UIButton().then {
            $0.layer.cornerRadius = wScale(27)/2.0
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.white, for: .disabled)
            $0.titleLabel?.font = .kScale(13, weight: .medium)
            $0.clipsToBounds = true
        }
    }()
}


