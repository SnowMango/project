
import UIKit
import Then
import Kingfisher

class RankingsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        rankings = ["1","2","3","4","5"]
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rankings: [String] = []
    
    @objc func showMoreRanking() {
        
    }
    
    private func setupUI() {
        // 添加卡片视图
        addSubview(titleLb)
        addSubview(timeLb)
        
        addSubview(cardView)
       
        cardView.addSubview(rankTitleLb)
        cardView.addSubview(weekRateTitleLb)
        cardView.addSubview(rateTitleLb)
        
        cardView.addSubview(mineView)
        mineView.addSubview(myHeadIV)
        mineView.addSubview(nameLb)
        mineView.addSubview(weakRateLb)
        mineView.addSubview(rateLb)
        
        cardView.addSubview(rankTableView)
        
        cardView.addSubview(checkRankingBtn)
        cardView.addSubview(moreIV)
        cardView.addSubview(lineView)
        
    
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(wScale(12))
        }
        
        timeLb.snp.makeConstraints { make in
            make.right.equalTo(wScale(-5))
            make.centerY.equalTo(titleLb)
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(5)
        }
        
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.height.equalTo(wScale(408))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        rankTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(42))
            make.bottom.equalTo(mineView.snp.top).offset(wScale(-12))
        }
        
        weekRateTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(142))
            make.bottom.equalTo(mineView.snp.top).offset(wScale(-12))
        }
        
        rateTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(235))
            make.bottom.equalTo(mineView.snp.top).offset(wScale(-12))
        }
        
        mineView.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.right.equalTo(wScale(-12))
            make.top.equalTo(wScale(44))
            make.height.equalTo(wScale(53))
        }
        
        myHeadIV.snp.makeConstraints { make in
            make.left.equalTo(wScale(33))
            make.centerY.equalToSuperview()
            make.height.width.equalTo(wScale(30))
        }
        
        nameLb.snp.makeConstraints { make in
            make.left.equalTo(myHeadIV.snp.right).offset(wScale(8))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(65))
        }
        
        weakRateLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLb.snp.right).offset(wScale(15))
            make.width.greaterThanOrEqualTo(wScale(65))
        }
        rateLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(weakRateLb.snp.right).offset(wScale(20))
            make.width.greaterThanOrEqualTo(wScale(65))
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(mineView.snp.bottom)
            make.left.equalTo(wScale(12))
            make.right.equalTo(wScale(-12))
            make.height.equalTo(wScale(251))
        }
        
        checkRankingBtn.snp.makeConstraints { make in
            make.top.equalTo(rankTableView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(wScale(-20))
            make.height.equalTo(wScale(24))
        }
        moreIV.snp.makeConstraints { make in
            make.left.equalTo(checkRankingBtn.snp.right).offset(5)
            make.centerY.equalTo(checkRankingBtn)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(checkRankingBtn.snp.bottom)
            make.left.right.equalTo(checkRankingBtn)
            make.height.equalTo(1)
        }
        
        cardView.addSubview(checkRankingBtn)
        cardView.addSubview(moreIV)
        cardView.addSubview(lineView)
        
        titleLb.text = "实盘大赛排行榜"
        timeLb.text = "截止时间：2025年03月18日"
        
        rankTitleLb.titleLabel.text = "用户排名"
        rankTitleLb.iconImageView.image = UIImage(named: "contact")
        
        weekRateTitleLb.titleLabel.text = "本周收益率"
        weekRateTitleLb.iconImageView.image = UIImage(named: "contact")
        
        rateTitleLb.titleLabel.text = "累计收益率"
        rateTitleLb.iconImageView.image = UIImage(named: "contact")
        
        nameLb.text = "我自己"
        weakRateLb.text = "--"
        rateLb.text = "0.00%"
    
    }
    
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
        }
    }()
    
    lazy var timeLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var cardView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var rankTitleLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = .kText2
            $0.titleLabel.font = .kScale(13)
        }
    }()
    lazy var weekRateTitleLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = .kText2
            $0.titleLabel.font = .kScale(13)
        }
    }()
    
    lazy var rateTitleLb: IconLabel = {
        IconLabel().then {
            $0.titleLabel.textColor = .kText2
            $0.titleLabel.font = .kScale(13)
        }
    }()
    
    lazy var mineView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .kBackGround
            $0.layer.cornerRadius = wScale(10)
        }
    }()

    lazy var myHeadIV: UIImageView = {
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
            $0.textColor = .kText2
            $0.font = .kScale(12,weight: .medium)
        }
    }()
    
    lazy var rateLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(12,weight: .medium)
        }
    }()
    
    
    lazy var rankTableView: UITableView = {
        return UITableView(frame: .zero, style: .plain).then {
            $0.separatorStyle = .singleLine
            $0.separatorColor = .kBackGround
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = wScale(50)
            $0.registerCell(cls: RankItemView.self, identifier: "RankItemView")
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    lazy var checkRankingBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.setTitle("查看完整排行榜", for: .normal)
            $0.setTitleColor(.kText2, for: .normal)
            $0.titleLabel?.font = .kScale(13, weight: .medium)
            $0.addTarget(self, action: #selector(showMoreRanking), for: .touchDown)
        }
    }()
    
    lazy var moreIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "dark.more.arrow")
        }
    }()
    
    lazy var lineView: UIView = {
        UIView().then {
            $0.backgroundColor = .kText2.withAlphaComponent(0.8)
        }
    }()
}

extension RankingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        min(rankings.count, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankItemView", for: indexPath) as! RankItemView
        cell.selectionStyle = .none
        return cell
    }

}
