
import UIKit
import Then

class HotStockItem: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(_ model: HotStockModel){
        jsyLb.text = model.jys
        nameLb.text = model.name
        if model.changePercent.hasPrefix("-") {
            precentLb.text = model.changePercent
            precentLb.textColor = UIColor("#119876")
        }else {
            precentLb.textColor = .kAlert3
            precentLb.text = "+\(model.changePercent)"
        }
    }
    
    func makeUI() {
        addSubview(jsyLb)
        addSubview(nameLb)
        addSubview(precentLb)
        jsyLb.snp.makeConstraints { make in
            make.width.equalTo(wScale(27))
            make.height.equalTo(wScale(16))
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        }
        
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(jsyLb.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        precentLb.snp.makeConstraints { make in
            make.left.equalTo(nameLb.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(0)
        }
    }

    lazy var jsyLb: UILabel = {
        UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(12, weight: .medium)
            $0.backgroundColor = .kAlert3
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
    }()
    
    lazy var nameLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var precentLb: UILabel = {
        UILabel().then {
            $0.font = .kScale(14, weight: .medium)
        }
    }()
}
