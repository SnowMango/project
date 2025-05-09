
import UIKit

class StrategyInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        self.backgroundColor = .white
        self.layer.cornerRadius = wScale(10)
        reloadData()
    }
    var strategy: StrategyProduct?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reloadData() {
        guard let strategy = self.strategy  else {
            return
        }
        titleLb.text = strategy.productName
        tagLb.text = strategy.productTag
        
        descLb.text = strategy.productDescription
       
        yearRateLb.text =  "+\(String(format: "%.2f", Float( strategy.backtestingAnnualizedReturnRate)))%"
        dayRateLb.text =  "+\(String(format: "%.2f", Float(strategy.backtestingDailyWinRate)))%"
    }
    
    func setupUI() {
        addSubview(titleLb)
        addSubview(tagLb)
        addSubview(descLb)
        addSubview(rateView)
        
        rateView.addSubview(yearRateTitleLb)
        rateView.addSubview(yearRateLb)
        rateView.addSubview(dayRateTitleLb)
        rateView.addSubview(dayRateLb)
    }
    
    func setupLayout() {
        titleLb.snp.makeConstraints { make in
            make.left.top.equalTo(wScale(14))
        }
        tagLb.snp.makeConstraints { make in
            make.right.equalTo(wScale(-14))
            make.centerY.equalTo(titleLb)
        }
        
        descLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(titleLb.snp.bottom).offset(wScale(8))
        }
        
        rateView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.bottom.equalTo(wScale(-16))
            make.top.equalTo(descLb.snp.bottom).offset(wScale(20))
        }
        yearRateTitleLb.snp.makeConstraints { make in
            make.top.equalTo(wScale(11))
            make.centerX.equalTo(yearRateLb)
            make.left.greaterThanOrEqualTo(wScale(10))
        }
        
        yearRateLb.snp.makeConstraints { make in
            make.top.equalTo(yearRateTitleLb.snp.bottom).offset(wScale(12))
            make.left.equalTo(wScale(19)).priority(.medium)
        }
        
        dayRateTitleLb.snp.makeConstraints { make in
            make.top.equalTo(wScale(11))
            make.centerX.equalTo(dayRateLb)
            make.left.greaterThanOrEqualTo(wScale(10))
        }
        
        dayRateLb.snp.makeConstraints { make in
            make.top.equalTo(dayRateTitleLb.snp.bottom).offset(wScale(12))
            make.right.equalTo(wScale(-50)).priority(.medium)
        }
    }
    
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(18, weight: .bold)
            $0.textColor = .kText2
        }
    }()
    
    lazy var tagLb: InsetLabel = {
        return InsetLabel().then {
            $0.backgroundColor = UIColor("#FAF6F0")
            $0.layer.cornerRadius = wScale(4)
            $0.font = .kScale(12, weight: .medium)
            $0.textColor = UIColor("#EE9200")
            $0.contentInsets = .init(top: 5, left: 6, bottom: 5, right: 6)
            $0.textAlignment = .center
        }
    }()
    
    lazy var descLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(12, weight: .medium)
            $0.textColor = .kText1
            $0.numberOfLines = 0
        }
    }()
    
    lazy var rateView: UIView = {
        return UIView().then {
            $0.backgroundColor = UIColor("#FCFAED")
            $0.layer.cornerRadius = wScale(4)
        }
    }()

    lazy var yearRateTitleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(13, weight: .medium)
            $0.textColor = .kText2
            $0.text = "回测年化收益率"
        }
    }()
    
    lazy var yearRateLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(20, weight: .bold)
            $0.textColor = .kAlert3
        }
    }()
    
    lazy var dayRateTitleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(13, weight: .medium)
            $0.textColor = .kText2
            $0.text = "回测日胜率"
        }
    }()
    
    lazy var dayRateLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(20, weight: .bold)
            $0.textColor = .kAlert3
        }
    }()
}
