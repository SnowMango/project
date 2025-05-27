
import UIKit
import Then
import Kingfisher

class HomeAccountView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(with board: StatusBoard) {
        let banner = board.pictures()?.first
        if let banner = banner {
            bannerIV.kf.setImage(with: URL(string: banner))
        }
        bannerIV.isHidden = banner == nil
        
        let precautions = board.mapPrecautions()
        descLb.text = precautions
        infoView.isHidden = precautions == nil
        
        doneBtn.setTitle(board.jumpLinkDescribe, for: .normal)
        goBtn.setTitle(board.buttonText, for: .normal)
    }
    
    //MARK: setup
    func setupUI() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(bannerIV)
    
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
        
        bannerIV.snp.makeConstraints { make in
            make.left.equalTo(wScale(9))
            make.height.equalTo(wScale(88))
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
            make.top.equalTo(contentStack.snp.bottom).offset(wScale(15))
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
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    

    lazy var bannerIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "home.strategy.bg3")
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
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    
    lazy var doneBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.kTheme, for: .normal)
            $0.titleLabel?.font = .kScale(13, weight: .medium)
        }
    }()
    
    lazy var goBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(8)
            $0.titleLabel?.font = .kScale(16, weight: .medium)
        }
    }()
}

