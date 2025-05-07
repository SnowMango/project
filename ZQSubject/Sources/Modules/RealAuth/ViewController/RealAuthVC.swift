
import UIKit
import Then
import SwiftyJSON

struct AuthResult: Decodable {
    let idCard: String
    let message: String
    let resultCode: Int
}

class RealAuthVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "实名认证"
        setupUI()
        setupLayout()
    }
    var needOpen: Bool = true
    //MARK: action
    @objc func commitAuth() {
        guard let name = nameTextField.text, name.count >= 2 else {
            view.showText(nameTextField.placeholder)
            return
        }
        guard let card = numberTextField.text, card.count == 18 else {
            view.showText(numberTextField.placeholder)
            return
        }
        view.showLoading()
        NetworkManager.shared.request(NoAuthTarget.realAuth(name: name, card: card)) { (result:NetworkResult<AuthResult>) in
            self.view.hideHud()
            do {
                let auth = try result.get()
                if auth.resultCode == 1 {
                    AppManager.shared.profile?.isRealName = 1
                    AppManager.shared.profile?.username = name;
                    AppManager.shared.profile?.idCard = card;
                    
                    var param: [String: String] = ["name": name, "idCard": card]
                    if !self.needOpen {
                        param["needOpen"] = "0"
                    }
                    Router.shared.route("/auth/result", parameters: param)
    
                }else {
                    self.view.showText("校验失败")
                }
            } catch NetworkError.server(_, let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("请求失败")
            }
        }
    }
    //MARK: setup
    private func setupUI() {
        view.addSubview(backgourdIV)

        view.addSubview(nameInputView)
        nameInputView.addSubview(nameTitleLb)
        nameInputView.addSubview(nameTextField)
        
        view.addSubview(numberInputView)
        numberInputView.addSubview(numberTitleLb)
        numberInputView.addSubview(numberTextField)
        
        view.addSubview(commitBtn)
        view.addSubview(tipLb)
        
        nameInputView.index = 0
        nameInputView.count = 2
        
        numberInputView.index = 1
        numberInputView.count = 2
    }
    
    
    private func setupLayout() {
        backgourdIV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(wScale(197))
        }
        nameInputView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(100))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
        nameTitleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(15))
            make.right.lessThanOrEqualTo(nameTextField.snp.left)
        }
        nameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(90))
            make.right.equalTo(wScale(-15))
        }
        
        numberInputView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(nameInputView.snp.bottom)
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
        
        numberTitleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(15))
            make.right.lessThanOrEqualTo(numberTextField.snp.left)
        }
        numberTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(90))
            make.right.equalTo(wScale(-15))
        }
        
        commitBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(28))
            make.top.equalTo(numberInputView.snp.bottom).offset(wScale(114))
            make.right.equalTo(wScale(-28))
            make.height.equalTo(48)
        }
        
        tipLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(commitBtn.snp.bottom).offset(wScale(12))
        }
    }
    //MARK: lazy
    lazy var backgourdIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "real.auth.bg")
        }
    }()
    
    
    lazy var nameInputView: SeparatorView = {
        return SeparatorView().then {
            $0.backgroundColor = .white
        }
    }()
    lazy var nameTitleLb: UILabel = {
        return UILabel().then {
            $0.text = "真实姓名："
            $0.textColor = UIColor("#252525")
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var nameTextField: UITextField = {
        return UITextField().then {
            $0.placeholder = "请输入您的真实姓名"
            $0.textColor = .kText2
            $0.font = .kScale(14)
        }
    }()
    
    
    lazy var numberInputView: SeparatorView = {
        return SeparatorView().then {
            $0.backgroundColor = .white
        }
    }()
    
    lazy var numberTitleLb: UILabel = {
        return UILabel().then {
            $0.text = "身份证号："
            $0.textColor = UIColor("#252525")
            $0.font = .kScale(14, weight: .bold)
        }
    }()
    
    lazy var numberTextField: UITextField = {
        return UITextField().then {
            $0.placeholder = "请输入您的真实身份证号"
            $0.textColor = .kText2
            $0.font = .kScale(14)
        }
    }()
    
    
    lazy var commitBtn:UIButton = {
        UIButton(type: .custom).then {
            $0.setTitle("立即认证", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(commitAuth), for: .touchUpInside)
        }
    }()
    
    lazy var tipLb: UILabel = {
        return UILabel().then {
            $0.text = "所填实名信息认证通过后不可更改"
            $0.textColor = .kText1
            $0.font = .kScale(12)
        }
    }()
    
}
