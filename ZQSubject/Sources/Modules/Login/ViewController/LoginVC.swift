
import UIKit

let ShowLoginReasonKey: String = "ShowLoginReasonKey"

class LoginVC: BaseViewController {
    var showReason: String? = nil
    private lazy var accoutField = {
        let field = LoginTextField(leftImage: "accout_holder", placeHolder: "请输入用户名称", cornerRadius: wScale(24), type: .normal)
        field.limitCount = 11
        field.editingChanged = {[self] text in
            self.fieldEditChanged()
        }
        return field
    }()
    
    private lazy var codeField = {
        let field = LoginTextField(leftImage: "code_holder", placeHolder: "请输入短信验证码", cornerRadius: wScale(24), type: .verifyCode)
        field.limitCount = 6
        field.getCode = { [self] in
            getCode()
        }
        field.editingChanged = {[self] text in
            self.fieldEditChanged()
        }
        return field
    }()
    
    private lazy var loginBtn = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .kScale(17)
        btn.layer.cornerRadius = wScale(24)
        btn.isEnabled = false
        btn.backgroundColor = .kText1
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    private lazy var checkBtn = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "checkbox_normal"), for: .normal)
        btn.setImage(UIImage(named: "checkbox_select"), for: .selected)
        btn.addTarget(self, action: #selector(checkBox), for: .touchUpInside)
        return btn
    }()
    
    ///协议
    lazy var protocolLabel: UILabel = {
        let label = UILabel()
        
        let attributeStr = NSMutableAttributedString(string: "开始使用代表您已同意《用户服务协议》、《隐私政策》")
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.kText2, range: NSMakeRange(0, 10))
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.kTheme, range: NSMakeRange(10, 8))
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.kTheme, range: NSMakeRange(19, 6))
        label.attributedText = attributeStr
        label.font = .kScale(12)
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProtocolAction(_:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.isHidden = true
        hiddenNavigationBarWhenShow = true
       
        initUI()

        if let phone = kUserDefault.string(forKey:  UserDefaultKey.phoneNum.rawValue) {
            accoutField.textField.text = phone
        }
        fieldEditChanged()
        if let reason = showReason {
            self.view.showText(reason)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func initUI() {
        view.backgroundColor = .white
        
        let titleLb = UILabel()
        titleLb.text = "账号登录"
        titleLb.font = .kScale(24)
        titleLb.textColor = .kText2
        view.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wScale(100) + kSafeTopH())
            make.left.equalToSuperview().offset(wScale(27))
        }
        
        view.addSubview(accoutField)
        accoutField.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(wScale(27))
            make.left.right.equalToSuperview().inset(wScale(27.5))
            make.height.equalTo(wScale(48))
        }
        
        view.addSubview(codeField)
        codeField.snp.makeConstraints { make in
            make.top.equalTo(accoutField.snp.bottom).offset(wScale(15))
            make.left.right.height.equalTo(accoutField)
        }
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(wScale(36))
            make.left.right.height.equalTo(accoutField)
        }
        
        view.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(30))
            make.left.equalToSuperview().offset(wScale(25))
            make.top.equalTo(loginBtn.snp.bottom).offset(wScale(18))
        }
        
        view.addSubview(protocolLabel)
        protocolLabel.snp.makeConstraints { make in
            make.left.equalTo(checkBtn.snp.right)
            make.height.equalTo(checkBtn)
            make.centerY.equalTo(checkBtn)
        }
    }
    
    private func fieldEditChanged() {
        if accoutField.textField.text?.count == 11 && codeField.textField.text?.count == 6 {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = .kTheme
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = .kText1
        }
        
        if accoutField.textField.text?.count == 11 {
            codeField.changeCutDownColor(state: 1)
        } else {
            codeField.changeCutDownColor(state: 0)
        }
    }
    
    @objc private func getCode() {
        let phoneNum = accoutField.textField.text ?? ""
        if (!phoneNum.isPhoneNumber()) {
            view.showText("请重新输入正确手机号")
            return
        }
        
        self.view.endEditing(true)
        HumanAlert(action: { [weak self] in
            self?.requsetSms(phoneNum)
        }, close: nil).show(to: self.view)
        
    }
    
    func requsetSms(_ phoneNum: String) {
        view.showLoading()
        NetworkManager.shared.request(NoAuthTarget.sendSms(mobile: phoneNum)) { (result:NetworkResult<JSON?>) in
            self.view.hideHud()
            switch result {
            case .success(_):
                self.codeField.timeCountdown()
                self.codeField.textField.becomeFirstResponder()
            case .failure(let error):
                switch error {
                case .server(_, let message):
                    self.view.showText(message)
                default:
                    self.view.showText("请求失败")
                }
            }
        }
    }
    
    @objc private func login() {
        let phoneNum = accoutField.textField.text ?? ""
        let code = codeField.textField.text ?? ""
        let isPhoneNum = phoneNum.isPhoneNumber()
        if (!isPhoneNum) {
            view.showText("请重新输入正确手机号")
            return
        }
        if (!checkBtn.isSelected) {
            view.showText("请勾选同意协议")
            return
        }
        
        view.endEditing(true)
        requestCheckLogin(phoneNum, code: code)
    }
    func requestCheckLogin(_ phone: String, code: String) {
        view.showLoading()
        NetworkManager.shared.request(NoAuthTarget.checkPhone(mobile: phone)) { (result: NetworkResult<Int>) in
            self.view.hideHud()
            do {
                let response = try result.get()
                if response == 5 {
                    let alert = WindowAlert(title: "登录提醒", content: "您正在申请注销中，若继续登录将撤销注销申请。", actionTitle: "继续", closeTitle: "取消", alertType: .double)
                    alert.show()
                    alert.doneCallBack = { [weak self] in
                        self?.requestLogin(phone, code: code)
                    }
                    return
                }
                self.requestLogin(phone, code: code)
            } catch NetworkError.server(_, let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("请求失败")
            }
        }
    }

    func requestLogin(_ phone: String, code: String) {
        
        view.showLoading()
        NetworkManager.shared.request(NoAuthTarget.login(mobile: phone, code: code)) {[weak self] (result:NetworkResult<LoginResponse>) in
            self?.view.hideHud()
            do {
                let response = try result.get()
                kUserDefault.set(response.mobile, forKey: UserDefaultKey.phoneNum.rawValue)
                kUserDefault.set(response.token, forKey: UserDefaultKey.userToken.rawValue)
                AppManager.shared.token = response.token
                
                self?.requestUserInfo()
            } catch NetworkError.server(let code, let message) {
                self?.view.showText(message)
                
            } catch {
                self?.view.showText("请求失败")
            }
        }
    }
    
    func requestUserInfo() {
        view.showLoading()
        NetworkManager.shared.request(AuthTarget.userinfo) { (result: NetworkResult<UserProfile>) in
            self.view.hideHud()
            do {
                let response = try result.get()
                AppManager.shared.profile = response
                AppManager.shared.loginInit()
                AppManager.shared.reportPush()
                if response.needDoQA() {
                    Router.shared.route("/qa")
                }else {
                    Router.shared.route(.home)
                }
            } catch NetworkError.server(_, let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("请求失败")
            }
        }
    }
    
    @objc private func checkBox() {
        checkBtn.isSelected = !checkBtn.isSelected
    }
    
    @objc func tapProtocolAction(_ sender: UITapGestureRecognizer) {

        if sender.didTapAttributedTextInLabel(label: protocolLabel, inRange: NSRange(location: 10, length: 8)) {
            AppLink.serviceTerms.routing()
        } else if sender.didTapAttributedTextInLabel(label: protocolLabel, inRange: NSRange(location: 19, length: 6)) {
            AppLink.privacyTerms.routing()
        }
    }
}
