
import UIKit
import Then

class BindSystemAccountVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleName = "绑定交易系统账户"
    }
    
    @objc func actionBind() {
        guard let account = inputField.text, account.count >= 6 && account.count <= 19 else {
            self.view.showText("请输入6-19位交易账户", isUserInteractionEnabled: true)
            return
        }
        
        NetworkManager.shared.request(AuthTarget.bindTrading(account)) { (result:OptionalJSONResult) in
            do {
                let _ = try result.get()
                AppManager.shared.profile?.tradingAccount = account
                self.navigationController?.popViewController(animated: false)
                Router.shared.route(AssetFlowView.FlowStep.strategy.path)
            } catch NetworkError.server(_,let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误,绑定失败")
            }
        }
        
    }
    
    func setupUI() {
        view.addSubview(contentView)
        contentView.addSubview(self.iconImageView)
        contentView.addSubview(self.titleLb)
        contentView.addSubview(self.inputField)
        
        view.addSubview(bindBtn)
        iconImageView.image = UIImage(named: "mini.account")
        titleLb.text = "交易账户"
        inputField.placeholder = "请输入交易账户"
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(10))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(50))
        }
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(22))
            make.left.equalTo(wScale(15))
            make.centerY.equalToSuperview()
        }
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(wScale(6))
        }
        inputField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(wScale(5))
            make.left.equalTo(wScale(150))
            make.right.equalTo(wScale(-15))
        }
        
        bindBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
    }
    lazy var contentView:UIView = {
        UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var iconImageView: UIImageView = {
        UIImageView()
    }()
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .init("#252525")
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var inputField: UITextField = {
        UITextField().then {
            $0.textColor = .kText1
            $0.font = .kScale(14)
            $0.delegate = self
        }
    }()
    
    lazy var bindBtn = {
        UIButton(type: .custom).then {
            $0.setTitle("绑定", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(actionBind), for: .touchUpInside)
        }
    }()
}

extension BindSystemAccountVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
