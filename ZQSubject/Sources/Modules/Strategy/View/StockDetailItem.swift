
import UIKit
import Then

class StockDetailItem: SeparatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoRadius = 0
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(desc: String?, color: UIColor){
        if let value = desc {
            self.descLb.attributedText = value.highlightNumbers(color: color, font: nil)
        } else {
            self.descLb.attributedText = nil
        }
        tagLb.backgroundColor = color
    }
    
    func makeUI() {
        addSubview(tagLb)
        addSubview(descLb)
    
        tagLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.top.equalTo(14)
        }
        
        descLb.snp.makeConstraints { make in
            make.left.equalTo(tagLb.snp.right).offset(10)
            make.top.equalTo(tagLb)
            make.right.lessThanOrEqualTo(wScale(-12))
            make.height.greaterThanOrEqualTo(tagLb)
            make.bottom.lessThanOrEqualTo(-14)
        }
    }

    lazy var tagLb: InsetLabel = {
        InsetLabel().then {
            $0.textColor = .white
            $0.font = .kScale(12, weight: .medium)
            $0.contentInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
            $0.text = "销售收现"
        }
    }()
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.numberOfLines = 0
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
}
