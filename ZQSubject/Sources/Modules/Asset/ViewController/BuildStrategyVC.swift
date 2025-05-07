
import UIKit
import Then

class BuildStrategyVC: BaseViewController {
    
    enum SectionItem {
        case quanshang
        case account
        case password
        
        case systemAccount
        case systemPassword
        case chuangye
        case strategy
        case shichang
        case zijin
        
        var indetifier: String {
            switch self {
            case .quanshang, .strategy:
                "BindAccountInfoCell"
            case .account,.password, .systemAccount, .systemPassword:
                "BindAccountInputCell"
            case .chuangye:
                "BindAccountToggleCell"
            case .shichang,.zijin:
                "BindAccountNumberCell"
            }
        }
        var secureText:Bool {
            switch self {
            case .password, .systemPassword:
                true
            default:
                false
            }
        }
        
        var icon: String {
            switch self {
            case .quanshang:
                "mini.quan"
            case .account, .systemAccount:
                "mini.account"
            case .password, .systemPassword:
                "mini.password"
            case .chuangye:
                "mini.chuang"
            case .strategy:
                "mini.compass"
            case .shichang:
                "mini.clock"
            case .zijin:
                "mini.wallet"
            }
        }
        
        var title: String {
            switch self {
            case .quanshang:
                "选择券商"
            case .account:
                "资金账户"
            case .password:
                "账户密码"
            case .systemAccount:
                "交易账户"
            case .systemPassword:
                "账户密码"
            case .chuangye:
                "是否开通创业板"
            case .strategy:
                "搭载策略"
            case .shichang:
                "搭载时长"
            case .zijin:
                "搭载资金"
            }
        }
        
        var placeholder: String {
            switch self {
            case .quanshang:
                ""
            case .account:
                "请输入资金账户"
            case .password:
                "请输入账户密码"
            case .systemAccount:
                "请输入交易账户"
            case .systemPassword:
                "请输入账户密码"
            case .chuangye, .strategy:
                ""
            case .shichang:
                "年"
            case .zijin:
                "元"
            }
        }
       
    }
    var items: [[BuildStrategyVC.SectionItem]] = [[.quanshang, .account, .password],
                                                  [.systemAccount,.systemPassword],
                                                  [.chuangye, .strategy],
                                                  [.shichang, .zijin]]
    
    var product: StrategyProduct?
    var strategyModel: StrategyModel = StrategyModel()
    var order: FundsOrder?
    
    private weak var fundsAccountInput: UITextField?
    private weak var fundsPasswordInput: UITextField?
    private weak var qmtPasswordInput: UITextField?
    private weak var boardBox: UIImageView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleName = "策略搭载"
        guard let profile = AppManager.shared.profile else { return }

        if let strategy = profile.quantitativeStrategyCarryInfoList?.first {
            // 审核结果 0未审核 1审核通过 2审核不通过
            if strategy.verificationResult == 0 {
                StrategyAlert(title: "温馨提示", content: "搭载中", desc: "策略搭载中，请您耐心等待", alertType: .info) {
                    Router.shared.route(.backHome)
                }.show()
                return
            }
            if strategy.verificationResult == 2 {
                StrategyAlert(title: "温馨提示", content: "搭载失败", desc:"失败原因:\(strategy.verificationMessage ?? "")" , alertType: .failure) {
                }.show()
            }
            requestStrategyInfo()
        }else{
            requestStrategyInfo()
        }
        self.strategyModel.fundAccount = profile.fundAccount
        self.strategyModel.tradingAccount = profile.tradingAccount
        self.strategyModel.userId = profile.id
    }

    @objc func commitClick() {
        guard let product = self.product else { return  }
        guard let order = self.order else { return }
        guard let profile = AppManager.shared.profile else { return }
       
        guard let fundsAccount = self.fundsAccountInput?.text, fundsAccount.count > 0 else {
            self.view.showText(self.fundsAccountInput?.placeholder)
            return
        }
        guard let fundsPWD = self.fundsPasswordInput?.text, fundsPWD.count > 0 else {
            self.view.showText(self.fundsPasswordInput?.placeholder)
            return
        }
        guard let qmtPWD = self.qmtPasswordInput?.text, qmtPWD.count > 0  else {
            self.view.showText(self.qmtPasswordInput?.placeholder)
            return
        }
        let commit: StrategyModel = StrategyModel()
        commit.carryInfoId = order.securityId
        commit.fundAccount = fundsAccount
        commit.fundPassword = fundsPWD
        
        if  self.boardBox?.isHighlighted == true {
            commit.isOpenChinextBoard = 1
        }else {
            commit.isOpenChinextBoard = 0
        }
        commit.quantitativeStrategyProductId = product.id
        commit.tradingAccount = profile.tradingAccount
        commit.tradingPassword = qmtPWD
        commit.userId = profile.id
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.buildStrategy(commit)) { (result: OptionalJSONResult) in
            self.view.hideHud()
            do {
                let _ = try result.get()

                StrategyAlert(title: "温馨提示", content: "搭载中", desc: "策略搭载中，请您耐心等待", alertType: .info) {
                    Router.shared.route(.backHome)
                }.show()
    
            } catch NetworkError.server(_,let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误，请求失败")
            }
        }
    }
    
    func requestStrategyInfo() {
        guard let profile = AppManager.shared.profile else { return }
        self.view.showLoading()
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.request(AuthTarget.orderList(profile.id)) { (result:NetworkPageResult<FundsOrder>) in
            do {
                let response = try result.get()
                self.order = response.records.first
            } catch {
                
            }
            group.leave()
        }
        group.enter()
        NetworkManager.shared.request(AuthTarget.strategyList) { (result: NetworkPageResult<StrategyProduct>) in
            do {
                let response = try result.get()
                self.product = response.records.first
            } catch {
                
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.view.hideHud()
            if self.product == nil {
                self.view.showText("产品获取信息失败")
                return
            }
            if self.order == nil {
                self.view.showText("订单获取信息失败")
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - setup
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.addSubview(backgourdIV)
        backgourdIV.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(wScale(197))
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    lazy var backgourdIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "build.strategy.banner")
        }
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: wScale(14), bottom: wScale(10), right: wScale(14))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            
            $0.register(BindAccountInputCell.self, forCellWithReuseIdentifier: "BindAccountInputCell")
            $0.register(BindAccountNumberCell.self, forCellWithReuseIdentifier: "BindAccountNumberCell")
            $0.register(BindAccountInfoCell.self, forCellWithReuseIdentifier: "BindAccountInfoCell")
            $0.register(BindAccountToggleCell.self, forCellWithReuseIdentifier: "BindAccountToggleCell")
            
            $0.register(BuildStrategyFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BuildStrategyFooter")
        }
    }()
   
}

extension BuildStrategyVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section][indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:item.indetifier, for: indexPath)
        if let cell = cell as? BuildStrategyCellProtocol {
            switch item {
            case .quanshang:
                if let order = order, let value = order.securityName {
                    cell.load(item: item, with: value)
                }else {
                    cell.load(item: item, with: "--")
                }
                
            case .account:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = true
                    self.fundsAccountInput = cell.inputField
                    cell.inputField.delegate = self
                }
                if let value = self.strategyModel.fundAccount {
                    cell.load(item: item, with: value)
                }else {
                    cell.load(item: item, with: "--")
                }
                
            case .password:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = true
                    self.fundsPasswordInput = cell.inputField
                    cell.inputField.delegate = self
                }
                cell.load(item: item, with: "")
            case .systemAccount:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = false
                }
                if let value = AppManager.shared.profile?.tradingAccount {
                    cell.load(item: item, with: value)
                }else {
                    cell.load(item: item, with: "")
                }
            case .systemPassword:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = true
                    self.qmtPasswordInput = cell.inputField
                    cell.inputField.delegate = self
                }
                cell.load(item: item, with: "")
            case .chuangye:
                if let cell = cell as? BindAccountToggleCell {
                    self.boardBox = cell.trueToggleLb.iconImageView
                }
                cell.load(item: item, with: "")
            case .strategy:
                if let value = product?.productName {
                    cell.load(item: item, with: value)
                }else {
                    cell.load(item: item, with: "--")
                }
            case .shichang:
                if let month = order?.carryTime {
                    let value = month/12
                    cell.load(item: item, with: "\(value)")
                }else {
                    cell.load(item: item, with: "--")
                }
            case .zijin:
                if let value = order?.carryFund {
                    cell.load(item: item, with: "\(Int(value))")
                } else {
                    cell.load(item: item, with: "--")
                }
            }
        }
        
        if let cell = cell as? BindAccountNumberCell{
            cell.inputField.isUserInteractionEnabled = false
        }
        cell.contentView.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BuildStrategyFooter", for: indexPath) as! BuildStrategyFooter
        
        footer.buildBtn.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(14)*2, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .init(top: wScale(105), left: wScale(14), bottom: wScale(10), right: wScale(14))
        }
        return .init(top: 0, left: wScale(14), bottom: wScale(10), right: wScale(14))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        if items.count == section + 1  {
             return CGSize(width: CGRectGetWidth(collectionView.frame), height: 120)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BuildStrategyVC: UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fundsAccountInput {
            
        }
        textField.resignFirstResponder()
        return true
    }
}


protocol BuildStrategyCellProtocol {
    func load(item: BuildStrategyVC.SectionItem, with Value: String)
}

