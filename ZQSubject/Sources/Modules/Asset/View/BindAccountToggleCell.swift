
import UIKit
import Then

class BindAccountToggleCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateToggle(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func updateToggle(_ on: Bool) {
        trueToggleLb.iconImageView.isHighlighted = on
        falseToggleLb.iconImageView.isHighlighted = !on
    }
    
    @objc func trueTaggleTap() {
        updateToggle(true)
    }
    
    @objc func falseTaggleTap() {
        updateToggle(false)
    }

    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLb)
        contentView.addSubview(trueToggleLb)
        contentView.addSubview(falseToggleLb)
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(22))
            make.left.equalTo(wScale(15))
            make.centerY.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(wScale(6))
        }
        
        trueToggleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        falseToggleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-18))
            make.left.equalTo(trueToggleLb.snp.right).offset(wScale(18))
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
    
    lazy var trueToggleLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = UIColor("#252525")
            $0.titleLabel.font = .kScale(14)
            $0.titleLabel.text = "是"
            $0.iconImageView.image = UIImage(named: "toggle.off")
            $0.iconImageView.highlightedImage = UIImage(named: "toggle.on")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(trueTaggleTap)))
        }
    }()
    lazy var falseToggleLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = UIColor("#252525")
            $0.titleLabel.font = .kScale(14)
            $0.titleLabel.text = "否"
            $0.iconImageView.image = UIImage(named: "toggle.off")
            $0.iconImageView.highlightedImage = UIImage(named: "toggle.on")
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(falseTaggleTap)))
        }
    }()
}

extension BindAccountToggleCell: BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
    }
}

extension BindAccountToggleCell: BuildStrategyCellProtocol {
    func load(item: BuildStrategyVC.SectionItem, with value: String) {
        self.iconImageView.image = UIImage(named: item.icon)
        self.titleLb.text = item.title
    }
}

