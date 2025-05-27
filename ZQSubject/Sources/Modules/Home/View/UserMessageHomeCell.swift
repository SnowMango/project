import UIKit
import Then
import Kingfisher

class UserMessageHomeCell: UICollectionViewCell {
    
    private var itemModel: UserMessageModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(with model: UserMessageModel) {
        nameLb.text = model.nickname
        self.itemModel = model
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let time = model.createTime, let da = fm.date(from: time) {
            fm.dateFormat = "yyyy年MM月dd日"
            timeLb.text = fm.string(from: da)
        }else {
            timeLb.text = nil
        }
        likesCountLb.titleLabel.text = "\(model.likes)"
        msgLb.text = model.content
        
        if let path = model.avater {
            headIV.kf.setImage(with: URL(string: path), placeholder: nil)
        }
        
        if let path = model.contentUrl {
            msgPictureIV.isHidden = false
            msgPictureIV.kf.setImage(with: URL(string: path), placeholder: nil)
        }else{
            msgPictureIV.isHidden = true
        }
    }
    
    @objc func showBigTap() {
        if let path = self.itemModel?.contentUrl {
            BrowseImageView.show(path)
        }
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = wScale(10)
        contentView.addSubview(headIV)
        contentView.addSubview(nameLb)
        contentView.addSubview(dayLb)
        contentView.addSubview(timeLb)
        
        dayLb.isHidden = true
        
        contentView.addSubview(msgStack)
        msgStack.addArrangedSubview(msgLb)
        msgStack.addArrangedSubview(msgPictureIV)
        
        contentView.addSubview(likesCountLb)
        likesCountLb.isHidden = true
        msgPictureIV.isUserInteractionEnabled = true
        msgPictureIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBigTap)))
    }
    
    func setupLayout() {
        headIV.snp.makeConstraints { make in
            make.left.equalTo(wScale(18))
            make.top.equalTo(wScale(16))
            make.width.height.equalTo(wScale(34))
        }
        
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(headIV.snp.right).offset(wScale(8))
            make.top.equalTo(headIV)
        }
        dayLb.snp.makeConstraints { make in
            make.left.equalTo(nameLb.snp.right).offset(wScale(6))
            make.centerY.equalTo(nameLb)
            make.width.equalTo(wScale(40))
            make.height.equalTo(wScale(14))
        }
        
        timeLb.snp.makeConstraints { make in
            make.left.equalTo(headIV.snp.right).offset(wScale(8))
            make.bottom.equalTo(headIV)
        }
        
        msgStack.snp.makeConstraints { make in
            make.left.equalTo(wScale(18))
            make.right.equalTo(wScale(-18))
            make.top.equalTo(headIV.snp.bottom).offset(wScale(10))
        }
        
        msgLb.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        msgPictureIV.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.height.equalTo(wScale(115))
        }
        
        likesCountLb.snp.makeConstraints { make in
            make.right.equalTo(wScale(-18))
            make.bottom.equalTo(wScale(-15))
            make.height.equalTo(wScale(20))
            make.top.greaterThanOrEqualTo(msgStack.snp.bottom).offset(wScale(6))
        }
    }
    
    lazy var headIV: UIImageView = {
        UIImageView().then {
            $0.layer.cornerRadius = wScale(34)/2.0
            $0.clipsToBounds = true
        }
    }()
    lazy var nameLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14,weight: .bold)
        }
    }()
    
    lazy var dayLb: UILabel = {
        UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(10, weight: .bold)
            $0.backgroundColor = UIColor("#FFC100", alpha: 1)
            $0.layer.cornerRadius = wScale(14)/2.0
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
    }()
    
    lazy var timeLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var msgStack: UIStackView = {
        return UIStackView().then {
            $0.spacing = wScale(12)
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
    }()
    lazy var msgLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.numberOfLines = 0
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    
    lazy var msgPictureIV: UIImageView = {
        UIImageView().then {
            $0.layer.cornerRadius = wScale(10)
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
    }()
    
    lazy var likesCountLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = .kText1
            $0.titleLabel.font = .kScale(14, weight: .bold)
            $0.titleLabel.text = "0"
            $0.iconImageView.isHidden = true
            $0.iconImageView.image = UIImage(named: "thumbsup")
        }
    }()
    
}
