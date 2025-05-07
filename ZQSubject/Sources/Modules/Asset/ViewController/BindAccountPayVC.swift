
import UIKit
import Then
import Kingfisher

class BindAccountPayVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleName = "绑定券商账户"
        
        guard let resource = AppManager.shared.resource(with: "payment_QR_code") else {
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
        qrBg.addSubview(qrCodeIV)
        qrBg.addSubview(descLb)
        view.addSubview(paidBtn)
    
        qrBg.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(18))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(420))
        }
        
        qrCodeIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: wScale(20), left: wScale(20), bottom: wScale(20), right: wScale(20)))
        }
        
        descLb.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
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
//            $0.image = UIImage(named: "pay.me.qrcode")
            $0.contentMode = .scaleAspectFill
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

