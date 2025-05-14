
import UIKit
import Then
import Kingfisher

class BindAccountPayVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleName = "绑定券商账户"
        
//        guard let resource = AppManager.shared.resource(with: "payment_QR_code") else {
//            return
//        }
        guard let resource = AppManager.shared.resource(with: "payment_QR_code2") else {
            return
        }
        if let qr = resource.data.first?.resourceUrl {
            qrCodeIV.kf.setImage(with: URL(string: qr))
        }
    }
    var commitModel: BindAccountModel?
    
    @objc func doneClick() {
        let alertView = PayInfoView()
        alertView.commitModel = self.commitModel
        alertView.controller = self
        alertView.backgroundColor = .black.withAlphaComponent(0.7)
        self.view.window?.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func setupUI() {
        view.addSubview(qrBg)
        qrBg.addSubview(qrContentIV)
        qrBg.addSubview(qrCodeIV)
        qrBg.addSubview(scanDescLb)
        qrBg.addSubview(stack)
        qrBg.addSubview(paywayDescLb)
        qrBg.addSubview(descLb)
        view.addSubview(paidBtn)
    
        let payways = ["pay.wechart", "pay.alipay", "pay.huabei", "pay.unionpay"]
        for item in payways {
            let iv = UIImageView(image: UIImage(named: item))
            stack.addArrangedSubview(iv)
        }
        
        qrBg.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(18))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(14))
        }
        
        qrContentIV.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(wScale(20))
            make.width.equalTo(wScale(307))
            make.height.equalTo(wScale(420))
        }
        
        qrCodeIV.snp.makeConstraints { make in
            make.top.equalTo(wScale(55))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(wScale(168))
        }
        
        scanDescLb.snp.makeConstraints { make in
            make.top.equalTo(qrCodeIV.snp.bottom).offset(wScale(26))
            make.centerX.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.bottom.equalTo(paywayDescLb.snp.top).offset(wScale(-12))
            make.centerX.equalToSuperview()
        }
        
        paywayDescLb.snp.makeConstraints { make in
            make.bottom.equalTo(descLb.snp.top).offset(wScale(-30))
            make.centerX.equalToSuperview()
        }
        
        descLb.snp.makeConstraints { make in
            make.bottom.equalTo(wScale(-40))
            make.centerX.equalToSuperview()
        }
        
        paidBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(qrBg.snp.bottom).offset(wScale(50))
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
    }

    lazy var qrBg: UIView = {
        UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var qrCodeIV: UIImageView = {
        UIImageView().then {
            $0.contentMode = .scaleAspectFill
        }
    }()
    
    lazy var qrContentIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "pay.qrcode.bg")
        }
    }()
    
    lazy var scanDescLb: UILabel = {
        UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(18, weight: .heavy)
            $0.textAlignment = .center
            $0.text = "请扫我付款"
        }
    }()
    
    lazy var stack: UIStackView = {
        return UIStackView().then {
            $0.spacing = 19
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }()
    
    lazy var paywayDescLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#0066B1")
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
            $0.text = "—支持主流支付方式—"
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText3
            $0.font = .kScale(14, weight: .medium)
            $0.textAlignment = .center
            $0.text = "支付成功点击下方按钮确认"
        }
    }()
    lazy var paidBtn = {
        UIButton(type: .custom).then {
            $0.setTitle("已扫码支付", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        }
    }()
}

