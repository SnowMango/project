
import UIKit
import Then

class RankItemView: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData() {
        self.rankIV.image = UIImage(named: "rank.gold")
        nameLb.text = "咖啡机电脑"
        weakRateLb.text = "+69.56%"
        rateLb.text = "+69.56%"
    }
    
    func setupUI() {
        contentView.addSubview(self.rankIV)
        contentView.addSubview(self.userHeadIV)
        contentView.addSubview(self.nameLb)
        contentView.addSubview(self.weakRateLb)
        contentView.addSubview(self.rateLb)
        rankIV.snp.makeConstraints { make in
            make.width.equalTo(27)
            make.centerY.equalToSuperview()
        }
        userHeadIV.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(30))
            make.centerY.equalToSuperview()
            make.left.equalTo(rankIV.snp.right).offset(wScale(2))
        }
        nameLb.snp.makeConstraints { make in
            make.centerY.equalTo(userHeadIV)
            make.left.equalTo(userHeadIV.snp.right).offset(wScale(8))
            make.width.equalTo(wScale(65))
        }
        
        weakRateLb.snp.makeConstraints { make in
            make.centerY.equalTo(userHeadIV)
            make.left.equalTo(nameLb.snp.right).offset(wScale(15))
            make.width.greaterThanOrEqualTo(wScale(65))
        }
        
        rateLb.snp.makeConstraints { make in
            make.centerY.equalTo(userHeadIV)
            make.left.equalTo(weakRateLb.snp.right).offset(wScale(20))
            make.width.greaterThanOrEqualTo(wScale(65))
        }
    }
    
    lazy var rankIV: UIImageView = {
        UIImageView()
    }()
    
    lazy var userHeadIV: UIImageView = {
        UIImageView().then {
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = wScale(30)/2.0
        }
    }()
    lazy var nameLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(12,weight: .medium)
        }
    }()
    
    lazy var weakRateLb: UILabel = {
        UILabel().then {
            $0.textColor = .kAlert2
            $0.font = .kScale(18, weight: .bold)
        }
    }()
    
    lazy var rateLb: UILabel = {
        UILabel().then {
            $0.textColor = .kAlert2
            $0.font = .kScale(18, weight: .bold)
        }
    }()
}
