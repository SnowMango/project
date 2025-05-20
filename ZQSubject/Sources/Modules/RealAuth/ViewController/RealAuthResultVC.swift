
import UIKit
import Then

class RealAuthResultVC: BaseViewController {
    
    var name: String = ""
    var cardNumber: String = ""
    var needOpen: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "实名认证"
        setupUI()
        setupLayout()
        if name.count > 1 {
            let range = name.index(name.startIndex, offsetBy: 1)..<name.index(name.startIndex, offsetBy: name.count)
            nameLb.text = name.replacingCharacters(in: range, with: "*")
        }
        if cardNumber.count == 18 {
            let range = cardNumber.index(cardNumber.startIndex, offsetBy: 5)..<cardNumber.index(cardNumber.startIndex, offsetBy: cardNumber.count - 2)
            numberLb.text = cardNumber.replacingCharacters(in: range, with: "******")
        }
        if needOpen {
            doneBtn.setTitle("去开户", for: .normal)
        }else {
            doneBtn.setTitle("完成", for: .normal)
        }
    }
    
    //MARK: action
    @objc func doneClick() {
        if needOpen {
            Router.shared.route("/open/account")
            return
        }
        Router.shared.route(.backHome)
    }
    
    override func baseBack() {
        Router.shared.route(.backHome)
    }
    
    //MARK: setup
    private func setupUI() {
        view.addSubview(backgourdIV)

        view.addSubview(nameItemView)
        nameItemView.addSubview(nameTitleLb)
        nameItemView.addSubview(nameLb)
        
        view.addSubview(numberItemView)
        numberItemView.addSubview(numberTitleLb)
        numberItemView.addSubview(numberLb)
        
        view.addSubview(doneBtn)
        
        nameItemView.index = 0
        nameItemView.count = 2
        
        numberItemView.index = 1
        numberItemView.count = 2
    }
    
    
    private func setupLayout() {
        backgourdIV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(wScale(247))
        }
        nameItemView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(backgourdIV.snp.bottom).offset(wScale(-40))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
        nameTitleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(15))
            make.right.lessThanOrEqualTo(nameLb.snp.left)
        }
        nameLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(90))
            make.right.equalTo(wScale(-15))
        }
        
        numberItemView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(nameItemView.snp.bottom)
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
        
        numberTitleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(15))
            make.right.lessThanOrEqualTo(numberLb.snp.left)
        }
        numberLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(90))
            make.right.equalTo(wScale(-15))
        }
        
        doneBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(28))
            make.top.equalTo(numberItemView.snp.bottom).offset(wScale(35))
            make.right.equalTo(wScale(-28))
            make.height.equalTo(wScale(48))
        }
        
    }
    //MARK: lazy
    lazy var backgourdIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "auth.success.bg")
        }
    }()
    
    
    lazy var nameItemView: SeparatorView = {
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
    
    lazy var nameLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14)
        }
    }()
    
    
    lazy var numberItemView: SeparatorView = {
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
    
    lazy var numberLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14)
        }
    }()
    
    
    lazy var doneBtn:UIButton = {
        UIButton(type: .custom).then {
            $0.setTitle("完成", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = wScale(48)/2.0
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        }
    }()

}
