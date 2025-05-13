
import UIKit
import Then

class MineNormalView: SeparatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.separatorInsets = .init(top: 0, left: wScale(10), bottom: 0, right: wScale(10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(mainLb)
        addSubview(moreImageView)
        mainLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(21))
            make.centerY.equalToSuperview()
        }

        moreImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(wScale(-21))
        }
    }
    
    lazy var mainLb: IconLabel = {
        IconLabel().then {
            $0.spacing = 13
            $0.titleLabel.textColor = .kText3
            $0.titleLabel.font = .kScale(14)
        }
    }()
   
    lazy var moreImageView: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "go_ahead")
        }
    }()
}

extension MineNormalView: MineItemLoadProtocol {
    func load(_ item: MineItemModel) {
        self.mainLb.titleLabel.text = item.title
        if let icon = item.iconName {
            self.mainLb.iconImageView.image = UIImage(named: icon)
        }
    }
}
