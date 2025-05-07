
import UIKit
import Then

class OrderListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        mock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mock() {
        titleLb.text = "首次支付"
        statusLb.text = "审核中"
        
        timeLb.titleLabel.text = "订单时间：2025-02-12 10:12:12"
        timeSeverLb.text = "服务器时长：1年"
        
        costSeverLb.text = "服务器费用：500元"
        fundsTimeLb.text = "搭载资金时长：1年"
        fundsLb.text = "搭载资金：12,345,6789元"
        costLb.text = "策略技术服务费：1000元"
        
        paidLb.text = "1500元"
    }
    func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = wScale(10)
        
        contentView.addSubview(titleLb)
        contentView.addSubview(statusLb)
        contentView.addSubview(infoView)
        
        infoView.addSubview(timeLb)
        infoView.addSubview(separatorView)
        infoView.addSubview(timeSeverLb)
        infoView.addSubview(costSeverLb)
        infoView.addSubview(fundsTimeLb)
        infoView.addSubview(fundsLb)
        infoView.addSubview(costLb)
        
        contentView.addSubview(paidTitleLb)
        contentView.addSubview(paidLb)
    }

    func setupLayout() {
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(wScale(18))
            make.left.equalTo(wScale(15))
        }
        statusLb.snp.makeConstraints { make in
            make.centerY.equalTo(titleLb)
            make.right.equalTo(wScale(-15))
        }
        
        infoView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.init(top: wScale(50), left: wScale(12), bottom: wScale(45), right: wScale(12)))
        }
        
        timeLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(wScale(15))
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.right.equalTo(wScale(-10))
            make.top.equalTo(wScale(36))
            make.height.equalTo(0.5)
        }
    
        timeSeverLb.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(wScale(14))
            make.left.equalTo(wScale(14))
        }
        costSeverLb.snp.makeConstraints { make in
            make.centerY.equalTo(timeSeverLb)
            make.left.equalTo(wScale(158))
            make.right.lessThanOrEqualTo(wScale(-10))
        }
        
        fundsTimeLb.snp.makeConstraints { make in
            make.top.equalTo(timeSeverLb.snp.bottom).offset(wScale(12))
            make.left.equalTo(wScale(14))
        }
        
        fundsLb.snp.makeConstraints { make in
            make.centerY.equalTo(fundsTimeLb)
            make.left.equalTo(wScale(158))
            make.right.lessThanOrEqualTo(wScale(-10))
        }
        
        costLb.snp.makeConstraints { make in
            make.top.equalTo(fundsTimeLb.snp.bottom).offset(wScale(12))
            make.left.equalTo(wScale(14))
            make.right.lessThanOrEqualTo(wScale(-10))
        }
        
        paidTitleLb.snp.makeConstraints { make in
            make.right.equalTo(paidLb.snp.left)
            make.bottom.equalTo(paidLb)
        }
        paidLb.snp.makeConstraints { make in
            make.right.bottom.equalTo(wScale(-15))
        }
    }

    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var statusLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#FB7E2B")
            $0.font = .kScale(13)
            $0.textAlignment = .right
        }
    }()
    
    lazy var infoView: UIView = {
        UIView().then {
            $0.backgroundColor = .kBackGround
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    lazy var timeLb: IconLabel = {
        IconLabel().then {
            $0.spacing = 3
            $0.titleLabel.textColor = .kText1
            $0.titleLabel.font = .kScale(12, weight: .medium)
            $0.iconImageView.image = UIImage(named: "mini.grey.clock")
        }
    }()
    lazy var separatorView: UIView = {
        UIView().then {
            $0.backgroundColor = UIColor("#EFEFEF")
            $0.layer.cornerRadius = 0.25
        }
    }()
    
    lazy var timeSeverLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(12)
            $0.textAlignment = .left
        }
    }()
    
    lazy var costSeverLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(12)
            $0.textAlignment = .left
        }
    }()
    
    lazy var fundsTimeLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(12)
            $0.textAlignment = .left
        }
    }()
    
    lazy var fundsLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(12)
            $0.textAlignment = .left
        }
    }()
    
    lazy var costLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(12)
            $0.textAlignment = .left
        }
    }()
    
    lazy var paidTitleLb: UILabel = {
        UILabel().then {
            $0.text = "实际付款总额："
            $0.textColor = .kText1
            $0.font = .kScale(12)
            $0.textAlignment = .right
        }
    }()
    
    lazy var paidLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#FC4B4B")
            $0.font = .kScale(15,weight: .medium)
            $0.textAlignment = .right
        }
    }()
}
