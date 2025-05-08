
import UIKit
import Then

class BindAccountVC: BaseViewController {
    enum SectionItem {
        case quanshang
        case account
        case shichang
        case dazaiziji
        case fuwufei
        case serverTime
        case server
        case total
        
        var indetifier: String {
            switch self {
            case .quanshang,.account:
                "BindAccountInputCell"
            case .shichang, .dazaiziji, .serverTime:
                "BindAccountNumberCell"
            default:
                "BindAccountInfoCell"
            }
        }
      
        var icon: String {
            switch self {
            case .quanshang:
                "mini.quan"
            case .account:
                "mini.account"
            case .shichang, .serverTime:
                "mini.clock"
            case .dazaiziji, .fuwufei, .server, .total:
                "mini.wallet"
            }
        }
        
        var title: String {
            switch self {
            case .quanshang:
                "选择券商"
            case .account:
                "资金账户"
            case .shichang:
                "搭载时长"
            case .dazaiziji:
                "搭载资金"
            case .fuwufei:
                "技术服务费"
            case .serverTime:
                "服务器时长"
            case .server:
                "服务器费用"
            case .total:
                "合计需支付费用"
            }
        }
        
        var placeholder: String {
            switch self {
            case .quanshang:
                "请输入"
            case .account:
                "请输入资金账户"
            case .shichang, .serverTime:
                "年"
            case .dazaiziji, .fuwufei, .total:
                "元"
            case .server:
                "元"
            }
        }
        
    }
    var items: [[BindAccountVC.SectionItem]] = [[.quanshang, .account],
                                                [.shichang,.dazaiziji,.fuwufei],
                                                [.serverTime,.server],
                                                [.total]]
    
    var dataModel: BindAccountModel = BindAccountModel()
    var rule: FundsRule?
    var canFree: Bool = true
    
    private weak var accountInput: UITextField?
    private weak var fundsInput: UITextField?
    private weak var fundsTimeInput: UITextField?
    
    private weak var severTimeInput: UITextField?
    private weak var agreementBox: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleName = "绑定券商账户"
        if self.canFree {
            dataModel.carryTime = 1
            dataModel.serviceTime = 1
        }
        guard let profile = AppManager.shared.profile else { return }
        if let order = profile.orderVerificationList?.first {
            if order.verificationResult == 0 {
                //有正在审核的订单
                StrategyAlert(title: "温馨提示", content: "审核中", desc: "财务审核中，请您耐心等待", alertType: .info) {
                    Router.shared.route(.backHome)
                }.show()
                return
            }
            if order.verificationResult == 2 {
                //有正在审核的订单
                StrategyAlert(title: "温馨提示", content: "绑定失败", desc: order.verificationMessage ?? "审核不通过" , alertType: .failure) {
                }.show()
            }
            requestFundInfo()
        }else {
            requestFundInfo()
        }
    }
    
    
    @objc func payAndBindClick() {
        guard let rule = self.rule else { return }
//        if self.agreementBox?.isSelected != true {
//            self.view.showText("请阅读并同意《用户合作协议》")
//            return
//        }
        guard let account = self.accountInput?.text, account.count > 0 else {
            self.view.showText(self.accountInput?.placeholder)
            return
        }
        guard let text = self.fundsTimeInput?.text, let fundsYear = Int(text)  else {
            self.view.showText("请输入正确的搭载时长")
            return
        }
        guard let text = self.fundsInput?.text, let funds = Float(text), funds >= rule.minCarryFund  else {
            self.view.showText("请输入不少于\(rule.minCarryFund)资金")
            return
        }
        guard let text = self.severTimeInput?.text, let severYear = Int(text)  else {
            self.view.showText("请输入正确的服务器时长")
            return
        }
        if severYear < fundsYear {
            self.view.showText("服务器时长不能低于搭载时长")
            return
        }
        
        let commit = BindAccountModel()
        commit.securityId = self.dataModel.securityId
        commit.securityName = self.dataModel.securityName
        commit.fundAccount = account
        
        commit.carryTime = self.dataModel.carryTime
        commit.serviceTime = self.dataModel.serviceTime
        
        commit.carryFund = funds
        commit.technicalServiceFee = self.dataModel.service(rule)
        
        commit.serviceFund = self.dataModel.server(rule)
        commit.totalFund = self.dataModel.total(rule)
        let vc = BindAccountPayVC()
        vc.commitModel = commit
        self.navigationController?.show(vc, sender: nil)
    }
    func updateData() {
        guard let rule = self.rule else { return }
        
        if self.canFree == false, let text = self.fundsTimeInput?.text, let fundsYear = Int(text) {
            self.dataModel.carryTime = fundsYear * 12
        }
        if let text = self.fundsInput?.text, let funds = Float(text), funds >= rule.minCarryFund {
            dataModel.carryFund = funds
        }
        if self.canFree == false, let text = self.severTimeInput?.text, let severYear = Int(text) {
            dataModel.serviceTime = severYear * 12
        }
    }
    
    func requestFundInfo() {
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.funds) { (result: NetworkResult<[SecurityResponse]>) in
            self.view.hideHud()
            do {
                let response = try result.get()
                if let fund = response.first {
                    self.dataModel.securityName = fund.securitiesName
                    self.dataModel.securityId = fund.id
                    self.collectionView.reloadData()
                    self.requestFunsRule()
                }
            } catch NetworkError.server(_,let message)  {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误")
            }
        }
    }
    
    func requestFunsRule() {
        guard let id = self.dataModel.securityId else { return }
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.fundRule(id)) { (result: NetworkResult<FundsRule>) in
            self.view.hideHud()
            do {
                let response = try result.get()
                self.rule = response
                self.dataModel.carryFund = response.minCarryFund
                self.collectionView.reloadData()
            } catch NetworkError.server(_,let message)  {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误")
            }
        }
    }
    
    // MARK: - setup
    private func setupUI() {
        view.addSubview(tipLb)
        view.addSubview(collectionView)
        tipLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.greaterThanOrEqualTo(0)
            make.height.equalTo(wScale(25))
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tipLb.snp.bottom).offset(2)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    lazy var tipLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(12)
            $0.textColor = UIColor("#FF5B54")
            $0.textAlignment = .center
            $0.text = "温馨提示：仅支持通过量界平台进行开户的账号进行绑定"
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
            $0.contentInset = UIEdgeInsets(top: 0, left: wScale(8), bottom: 0, right: wScale(8))
            
            $0.register(BindAccountInputCell.self, forCellWithReuseIdentifier: "BindAccountInputCell")
            $0.register(BindAccountNumberCell.self, forCellWithReuseIdentifier: "BindAccountNumberCell")
            $0.register(BindAccountInfoCell.self, forCellWithReuseIdentifier: "BindAccountInfoCell")
            
            $0.register(BindAccountFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BindAccountFooter")
            
        }
    }()
   
}

extension BindAccountVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section][indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:item.indetifier, for: indexPath)
       
        if let cell = cell as? BindAccountCellProtocol {
            switch item {
            case .quanshang:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = false
                }
                cell.load(item: item, with: dataModel.securityName ?? "--")
            case .account:
                if let cell = cell as? BindAccountInputCell {
                    cell.inputField.isUserInteractionEnabled = true
                    self.accountInput = cell.inputField
                    cell.inputField.delegate = self
                }
                cell.load(item: item, with: "")
            case .shichang:
                if let cell = cell as? BindAccountNumberCell {
                    cell.inputField.isUserInteractionEnabled = !self.canFree
                    self.fundsTimeInput = cell.inputField
                    cell.inputField.delegate = self
                }
                
                var value = dataModel.carryTime/12
                var placeholder = item.placeholder
                if dataModel.carryTime < 12 {
                    value = dataModel.carryTime*30
                    placeholder = "天"
                }
                if self.canFree {
                    cell.load(item: item, with:  "\(value)",placeholder: placeholder)
                }else{
                    cell.load(item: item, with:  "\(value)")
                }
                
            case .dazaiziji:
                if let cell = cell as? BindAccountNumberCell {
                    cell.inputField.isUserInteractionEnabled = true
                    self.fundsInput = cell.inputField
                    cell.inputField.delegate = self
                }
                cell.load(item: item, with: "\(Int(dataModel.carryFund))")
            case .fuwufei:
                var value: String = "--"
                if let rule = rule {
                    if self.canFree {
                        value = "免费体验"
                        cell.load(item: item, with: value, placeholder: nil, placeholderColor: .kAlert3)
                    } else{
                        value = "\(Int(dataModel.service(rule, free: self.canFree)))"
                        cell.load(item: item, with: value)
                    }
                }else{
                    cell.load(item: item, with: value)
                }
                
            case .serverTime:
                if let cell = cell as? BindAccountNumberCell {
                    self.severTimeInput = cell.inputField
                    cell.inputField.delegate = self
                    cell.inputField.isUserInteractionEnabled = !self.canFree
                }
                var value = dataModel.serviceTime/12
                var placeholder = item.placeholder
                if dataModel.serviceTime < 12 {
                    value = dataModel.serviceTime*30
                    placeholder = "天"
                }
                if self.canFree {
                    cell.load(item: item, with: "\(value)",placeholder: placeholder,placeholderColor: .kAlert3)
                }else{
                    cell.load(item: item, with: "\(value)")
                }
            case .server:
                var value: String = "--"
                if let rule = rule {
                    if self.canFree {
                        value = "免费体验"
                        cell.load(item: item, with: value, placeholder: nil, placeholderColor: .kAlert3)
                    } else{
                        value = "\(Int(dataModel.server(rule, free: self.canFree)))"
                        cell.load(item: item, with: value)
                    }
                }else {
                    cell.load(item: item, with: value)
                }
               
            case .total:
                var value: String = "--"
                if let rule = rule {
                    value = "\(Int(dataModel.total(rule, free: self.canFree)))"
                }
                if self.canFree {
                    cell.load(item: item, with: value,placeholder: item.placeholder, placeholderColor:  .kAlert3)
                }else{
                    cell.load(item: item, with: value)
                }
            }
        }
        
        cell.contentView.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "BindAccountFooter", for: indexPath) as! BindAccountFooter
        
        footer.payAndBindBtn.addTarget(self, action: #selector(payAndBindClick), for: .touchUpInside)
//        self.agreementBox = footer.checkBtn
        footer.freeInfoView.isHidden = !self.canFree
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(14)*2, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if items.count == section + 1  {
             return CGSize(width: CGRectGetWidth(collectionView.frame), height: 140)
        }
        return .zero
    }
    
}

extension BindAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField == self.fundsTimeInput || textField == self.severTimeInput {
            if string == "." { return false }
            if let _ = Int(updatedText){
                return true
            }
            return false
        }
        if textField == self.fundsInput  {
            if string == "." { return false }
            if let _ = Int(updatedText){
                return true
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let updatedText = textField.text ?? ""
        if textField == self.fundsTimeInput  {
            if let number = Int(updatedText){
                if number < 1 {
                    textField.text = "\(dataModel.carryTime/12)"
                } else if number > 100{
                    textField.text = "100"
                }
            }
        } else if textField == self.severTimeInput  {
            if let number = Int(updatedText){
                if number < 1 {
                    textField.text = "\(dataModel.serviceTime/12)"
                }else if number > 100{
                    textField.text = "100"
                }
            }
        } else if textField == self.fundsInput  {
            if let number = Float(updatedText), let rule = rule{
                if number < rule.minCarryFund {
                    textField.text = "\(Int(rule.minCarryFund))"
                    self.view.showText("请输入不少于\(Int(rule.minCarryFund))资金")
                }
            }
        }
        updateData()
        self.collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with value: String)
    func load(item: BindAccountVC.SectionItem, with value: String, placeholder: String?)
    func load(item: BindAccountVC.SectionItem, with value: String, placeholder: String?, placeholderColor: UIColor?)
}

extension BindAccountCellProtocol {
    func load(item: BindAccountVC.SectionItem, with Value: String, placeholder: String?) {}
    func load(item: BindAccountVC.SectionItem, with value: String, placeholder: String?, placeholderColor: UIColor? ) {}
}
