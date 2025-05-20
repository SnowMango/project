
import UIKit
import Then

class HomeAccountView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    //MARK: setup
    func setupUI() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(advView)
        
        advView.addSubview(advBGIV)
        advView.addSubview(ad1IV)
        advView.addSubview(ad2IV)
        advView.addSubview(ad1DescLb)
        advView.addSubview(ad2DescLb)
        advView.addSubview(advLineView)
        
        contentStack.addArrangedSubview(infoView)
        infoView.addSubview(descTitleLb)
        infoView.addSubview(descLb)
        
        addSubview(doneBtn)
        addSubview(goBtn)
        
        contentStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(wScale(10))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        advView.snp.makeConstraints { make in
            make.left.equalTo(wScale(9))
            make.height.equalTo(wScale(87))
        }
        
        advBGIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        ad1IV.snp.makeConstraints { make in
            make.left.equalTo(wScale(19))
            make.top.equalTo(wScale(15))
        }
        
        ad1DescLb.snp.makeConstraints { make in
            make.left.equalTo(ad1IV).offset(2)
            make.top.equalTo(ad1IV.snp.bottom).offset(wScale(2))
        }
        
        advLineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(wScale(33))
            make.width.equalTo(1)
        }
        
        ad2IV.snp.makeConstraints { make in
            make.left.equalTo(advLineView.snp.right).offset(wScale(18))
            make.top.equalTo(wScale(15))
        }
        
        ad2DescLb.snp.makeConstraints { make in
            make.left.equalTo(ad2IV).offset(2)
            make.top.equalTo(ad2IV.snp.bottom).offset(wScale(2))
        }
        
        infoView.snp.makeConstraints { make in
            make.left.equalTo(wScale(15))
        }

        descTitleLb.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(wScale(5))
        }
        
        descLb.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(descTitleLb.snp.bottom).offset(wScale(8))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentStack.snp.bottom).offset(wScale(16))
        }

        goBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.right.equalTo(wScale(-12))
            make.top.equalTo(doneBtn.snp.bottom).offset(wScale(10))
            make.height.equalTo(wScale(44))
            make.bottom.lessThanOrEqualTo(wScale(-14))
        }
    }
    
    lazy var contentStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 10
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var advView: UIView = {
        UIView()
    }()
    
    lazy var advBGIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "home.strategy.bg3")
        }
    }()
    
    lazy var ad1IV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "quick.step")
        }
    }()
    
    lazy var ad1DescLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#75593D")
            $0.font = .kScale(12, weight: .medium)
            $0.numberOfLines = 0
            $0.text = "开户即可畅读市场资讯\n开户免费体验"
        }
    }()
    
    lazy var ad2IV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "understanding")
        }
    }()
    
    lazy var ad2DescLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#75593D")
            $0.font = .kScale(12, weight: .medium)
            $0.numberOfLines = 0
            $0.text = "为您精选智能量化策略\n开户免费体验"
        }
    }()
    
    lazy var advLineView: UIView = {
        UIView().then {
            $0.backgroundColor = UIColor("#F0D4A4")
        }
    }()
    
    lazy var infoView: UIView = {
        UIView()
    }()
    
    lazy var descTitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(13, weight: .bold)
            $0.text = "注意事项："
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    
    lazy var descLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#5D708B")
            $0.font = .kScale(12, weight: .medium)
            $0.numberOfLines = 0
            $0.text = "1.需通过专属机构开户码开户，可通过在线客服或专属顾问获取；\n2.量化交易可能导致亏损，仅适合风险承受能力较高的投资者；\n3.开户后须在券商账户上放入搭载资金一个工作日；\n4.开户审核约需一个工作日，请耐心等待。"
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    
    lazy var doneBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.kTheme, for: .normal)
            $0.titleLabel?.font = .kScale(13, weight: .medium)
            $0.setTitle("已有帐户？去绑定", for: .normal)
//            $0.addTarget(self, action: #selector(bindClick), for: .touchUpInside)
        }
    }()
    
    lazy var goBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(8)
            $0.titleLabel?.font = .kScale(16, weight: .medium)
            $0.setTitle("去开户", for: .normal)
//            $0.addTarget(self, action: #selector(bindClick), for: .touchUpInside)
        }
    }()
}

