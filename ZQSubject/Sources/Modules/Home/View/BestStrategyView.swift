
import UIKit
import Then

class BestStrategyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goClick() {
        
    }
    
    func updateData() {
        self.nameLb.text = "50股小盘A"
        self.descLb.text = "策略描述策略描述"
        self.rateLb.text = "+69.56%"
        self.rateDescLb.text = "累计收益率"
    }
    //MARK: setup
    func setupUI() {
        self.titleLb.text = "策略优选"
        
        addSubview(titleLb)
        addSubview(cardView)
        
        cardView.addSubview(nameLb)
        cardView.addSubview(descLb)
        cardView.addSubview(rateLb)
        cardView.addSubview(rateDescLb)
        cardView.addSubview(chartIV)
        cardView.addSubview(goStrategyBtn)
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(12)
            make.right.greaterThanOrEqualTo(0)
        }
        
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(0)
        }
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(18))
            make.top.equalTo(wScale(22))
        }
        
        descLb.snp.makeConstraints { make in
            make.leading.equalTo(nameLb)
            make.top.equalTo(nameLb.snp.bottom).offset(wScale(5))
        }
        rateLb.snp.makeConstraints { make in
            make.leading.equalTo(nameLb)
            make.top.equalTo(descLb.snp.bottom).offset(wScale(20))
        }
        rateDescLb.snp.makeConstraints { make in
            make.left.equalTo(rateLb.snp.right).offset(wScale(15))
            make.lastBaseline.equalTo(rateLb)
        }
        chartIV.snp.makeConstraints { make in
            make.top.equalTo(wScale(15))
            make.right.equalTo(wScale(-18))
            make.width.equalTo(wScale(100))
            make.height.equalTo(wScale(80))
        }
        
        goStrategyBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(rateLb.snp.bottom).offset(wScale(22))
            make.height.equalTo(wScale(44))
            make.bottom.lessThanOrEqualTo(wScale(-20))
        }
    }
    
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
        }
    }()
    /// 整个背景卡片
    private let cardView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var nameLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .heavy)
        }
    }()
    lazy var descLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var rateLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kAlert2
            $0.font = .kScale(28, weight: .bold)
        }
    }()
    lazy var rateDescLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var chartIV: UIImageView = {
        UIImageView().then {
            $0.backgroundColor = .gray
        }
    }()
    
    lazy var goStrategyBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitle("去看看", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(6)
            $0.titleLabel?.font = .kScale(16, weight: .medium)
            $0.addTarget(self, action: #selector(goClick), for: .touchUpInside)
        }
    }()
}
