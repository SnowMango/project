
import UIKit

class StockDetailVC: BaseViewController {

    var stockCode: String!
    var stockName: String?
    
    var stock: Stock?
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        titleLb.text = stockName
        codeLb.text = stockCode
        
        requestStock(stockCode)
    }

    func makeUI() {
        titleView.addSubview(titleLb)
        titleView.addSubview(codeLb)
        navigationItem.titleView = titleView
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(infoView)
        
        infoView.addSubview(odTitleLb)
        infoView.addSubview(odLb)
        
        infoView.addSubview(pcTitleLb)
        infoView.addSubview(pcLb)
        
        infoView.addSubview(upTitleLb)
        infoView.addSubview(upLb)
        
        infoView.addSubview(dpTitleLb)
        infoView.addSubview(dpLb)
        
        infoView.addSubview(fvTitleLb)
        infoView.addSubview(fvLb)
        
        infoView.addSubview(tvTitleLb)
        infoView.addSubview(tvLb)
        
        infoView.addSubview(pkTitleLb)
        infoView.addSubview(pkLb)
        
        infoView.addSubview(isTitleLb)
        infoView.addSubview(isLb)
        
        contentView.addSubview(pointView)
        pointView.addSubview(pointLb)
        pointView.addSubview(pointStack)
        pointStack.addArrangedSubview(qualityView)
        pointStack.addArrangedSubview(salesView)
        pointStack.addArrangedSubview(liquidityView)

        contentView.addSubview(warningView)
        warningView.addSubview(warningLb)
        warningView.addSubview(warningStack)
        warningStack.addArrangedSubview(peRatioView)
        warningStack.addArrangedSubview(pbRatioView)
        warningStack.addArrangedSubview(netProfitView)
        warningStack.addArrangedSubview(revenueView)
        warningStack.addArrangedSubview(fundHoldingView)
        
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        codeLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
       
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(wScale(12))
            make.left.equalTo(wScale(14))
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        }
        
        odTitleLb.snp.makeConstraints { make in
            make.top.equalTo(wScale(18))
            make.left.equalTo(wScale(12))
        }
        
        odLb.snp.makeConstraints { make in
            make.top.equalTo(odTitleLb.snp.bottom).offset(10)
            make.left.equalTo(odTitleLb)
        }
        
        pcTitleLb.snp.makeConstraints { make in
            make.top.equalTo(wScale(18))
            make.left.equalTo(wScale(183))
        }
        
        pcLb.snp.makeConstraints { make in
            make.top.equalTo(pcTitleLb.snp.bottom).offset(10)
            make.left.equalTo(pcTitleLb)
        }
        
        upTitleLb.snp.makeConstraints { make in
            make.top.equalTo(odTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(odTitleLb)
        }
        
        upLb.snp.makeConstraints { make in
            make.top.equalTo(upTitleLb.snp.bottom).offset(10)
            make.left.equalTo(upTitleLb)
        }
        
        dpTitleLb.snp.makeConstraints { make in
            make.top.equalTo(pcTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(pcTitleLb)
        }
        
        dpLb.snp.makeConstraints { make in
            make.top.equalTo(dpTitleLb.snp.bottom).offset(10)
            make.left.equalTo(dpTitleLb)
        }
    
        fvTitleLb.snp.makeConstraints { make in
            make.top.equalTo(upTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(upTitleLb)
        }
        
        fvLb.snp.makeConstraints { make in
            make.top.equalTo(fvTitleLb.snp.bottom).offset(10)
            make.left.equalTo(fvTitleLb)
        }
    
        tvTitleLb.snp.makeConstraints { make in
            make.top.equalTo(dpTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(dpTitleLb)
        }
        
        tvLb.snp.makeConstraints { make in
            make.top.equalTo(tvTitleLb.snp.bottom).offset(10)
            make.left.equalTo(tvTitleLb)
        }

        pkTitleLb.snp.makeConstraints { make in
            make.top.equalTo(fvTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(fvTitleLb)
        }
        
        pkLb.snp.makeConstraints { make in
            make.top.equalTo(pkTitleLb.snp.bottom).offset(10)
            make.left.equalTo(pkTitleLb)
        }
        
        isTitleLb.snp.makeConstraints { make in
            make.top.equalTo(tvTitleLb.snp.bottom).offset(wScale(40))
            make.left.equalTo(tvTitleLb)
        }
        
        isLb.snp.makeConstraints { make in
            make.top.equalTo(isTitleLb.snp.bottom).offset(10)
            make.left.equalTo(isTitleLb)
            make.bottom.lessThanOrEqualTo(wScale(-12))
        }
        
        pointView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(18)
            make.left.equalTo(wScale(14))
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(-18)
        }
        
        pointLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.top.equalTo(wScale(16))
        }
        
        pointStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(pointLb.snp.bottom)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        qualityView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        
        salesView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }

        liquidityView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        
        warningView.snp.makeConstraints { make in
            make.top.equalTo(pointView.snp.bottom).offset(18)
            make.left.equalTo(wScale(14))
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(-18)
            make.height.greaterThanOrEqualTo(100)
        }
        
        warningLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(12))
            make.top.equalTo(wScale(16))
        }
        
        warningStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(warningLb.snp.bottom)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        peRatioView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        
        pbRatioView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }

        netProfitView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
        
        revenueView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }

        fundHoldingView.snp.makeConstraints { make in
            make.left.equalTo(0)
        }
    }
    
    lazy var titleView: UIView = {
        UIView()
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var codeLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .clear
        }
    }()

    lazy var infoView: RadiusView = {
        RadiusView().then {
            $0.backgroundColor = UIColor("#FCFAED")
            $0.clipsToBounds = true
        }.gradient {
            $0.colors = [UIColor(0xFFFFFF).cgColor,UIColor(0xFCFAED).cgColor]
            $0.startPoint = CGPoint(x: 0.5, y: 1)
            $0.endPoint = CGPoint(x: 0.5, y: 0)
            $0.locations = [0, 1]
        }
    }()
    
    lazy var odTitleLb: UILabel = {
        UILabel().then {
            $0.text = "上市日期"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var odLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var pcTitleLb: UILabel = {
        UILabel().then {
            $0.text = "前收盘价格"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var pcLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var upTitleLb: UILabel = {
        UILabel().then {
            $0.text = "当日涨停价"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var upLb: UILabel = {
        UILabel().then {
            $0.textColor = .kAlert3
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var dpTitleLb: UILabel = {
        UILabel().then {
            $0.text = "当日跌停价"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var dpLb: UILabel = {
        UILabel().then {
            $0.textColor = .kGreen
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var fvTitleLb: UILabel = {
        UILabel().then {
            $0.text = "流通股本"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var fvLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var tvTitleLb: UILabel = {
        UILabel().then {
            $0.text = "总股本"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var tvLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var pkTitleLb: UILabel = {
        UILabel().then {
            $0.text = "最小价格变动单位"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var pkLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var isTitleLb: UILabel = {
        UILabel().then {
            $0.text = "股票停牌状态"
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
        }
    }()
    
    lazy var isLb: InsetLabel = {
        InsetLabel().then {
            $0.contentInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
            $0.textColor = .kTheme
            $0.font = .kScale(12, weight: .medium)
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
        }
    }()
    
    
    lazy var pointView: RadiusView = {
        RadiusView().then {
            $0.backgroundColor = .white
        }
    }()

    lazy var pointLb: UILabel = {
        UILabel().then {
            $0.text = "投资亮点"
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var pointStack: UIStackView = {
        UIStackView().then {
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var qualityView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 0
            $0.index = 3
            $0.tagLb.text = "收益质量"
        }
    }()
    
    lazy var salesView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 1
            $0.index = 3
            $0.tagLb.text = "销售收现"
        }
    }()
    
    lazy var liquidityView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 2
            $0.index = 3
            $0.tagLb.text = "资金流动"
        }
    }()
    
    lazy var warningView: RadiusView = {
        RadiusView().then {
            $0.backgroundColor = .white
        }
    }()
    
    lazy var warningLb: UILabel = {
        UILabel().then {
            $0.text = "风险预警"
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var warningStack: UIStackView = {
        UIStackView().then {
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()

    lazy var peRatioView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 0
            $0.index = 5
            $0.tagLb.text = "市盈率"
        }
    }()
    
    lazy var pbRatioView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 1
            $0.index = 5
            $0.tagLb.text = "市净率"
        }
    }()
    
    lazy var netProfitView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 2
            $0.index = 5
            $0.tagLb.text = "净利润"
        }
    }()
    
    lazy var revenueView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 3
            $0.index = 5
            $0.tagLb.text = "营收"
        }
    }()
    
    lazy var fundHoldingView: StockDetailItem = {
        StockDetailItem().then {
            $0.index = 4
            $0.index = 5
            $0.tagLb.text = "基金"
        }
    }()
    
}

extension StockDetailVC {
    
    func reloadData() {
        guard let stock = self.stock else { return }
        let fm = DateFormatter()
        fm.dateFormat = "yyyyMMdd"
        if let value = stock.baseInfo.od, let up = fm.date(from: value) {
            fm.dateFormat = "yyyy-MM-dd"
            self.odLb.text = fm.string(from: up)
        }else {
            self.odLb.text = "--"
        }
       
        if let value =  stock.baseInfo.pc {
            self.pcLb.text = "\(value)"
        }else {
            self.pcLb.text = "--"
        }
        if let value =  stock.baseInfo.up {
            self.upLb.text = "\(value)"
        }else {
            self.upLb.text = "--"
        }
        if let value =  stock.baseInfo.dp {
            self.dpLb.text = "\(value)"
        }else {
            self.dpLb.text = "--"
        }
        
        if let value =  stock.baseInfo.fv {
            self.fvLb.text = "\(Int(value))"
        }else {
            self.fvLb.text = "--"
        }
        
        if let value =  stock.baseInfo.tv {
            self.tvLb.text = "\(Int(value))"
        }else {
            self.tvLb.text = "--"
        }
        
        if let value =  stock.baseInfo.pk {
            self.pkLb.text = "\(value)"
        }else {
            self.pkLb.text = "--"
        }
        var status: String = "复牌"
        if stock.baseInfo.is == 0 {
            self.isLb.textColor = .kTheme
            self.isLb.backgroundColor = UIColor(0xF5F8FF)
            status = "正常交易"
        } else if stock.baseInfo.is < 0 {
            self.isLb.textColor = UIColor(0xE42D3C)
            self.isLb.backgroundColor = UIColor(0xFFF5F6)
            status = "停牌"
        } else {
            self.isLb.textColor = UIColor(0xFF8534)
            self.isLb.backgroundColor = UIColor(0xFFF9F5)
        }
        self.isLb.text = status
        
        qualityView.reload(desc: stock.incomeQuality, color: UIColor(0xE42D3C))
        salesView.reload(desc: stock.salesCash, color: UIColor(0xE42D3C))
        liquidityView.reload(desc: stock.liquidity, color: UIColor(0xE42D3C))
       
        peRatioView.reload(desc: stock.peRatio, color: .kGreen)
        pbRatioView.reload(desc: stock.pbRatio, color: .kGreen)
        netProfitView.reload(desc: stock.netProfit, color: .kGreen)
        revenueView.reload(desc: stock.revenue, color: .kGreen)
        fundHoldingView.reload(desc: stock.fundHolding, color: .kGreen)
    }
    
    func requestStock(_ code: String) {
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.stockDetail(code)) { (result: NetworkResult<Stock>) in
            self.view.hideHud()
            do {
                let response = try result.get()
                self.stock = response
                self.reloadData()
            } catch NetworkError.server(_, let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("信息请求失败")
            }
        }
    }
    
}
