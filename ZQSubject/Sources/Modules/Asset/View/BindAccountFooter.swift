
import UIKit
import Then

class BindAccountFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func changeCheckBox() {
        self.checkBtn.isSelected = !self.checkBtn.isSelected
    }
    
    @objc func showAgreement() {
        JumpManager.jumpToWeb(AppLink.cooperationTerms.path)
    }
    
    func setupUI() {
        addSubview(payAndBindBtn)
        addSubview(checkBtn)
        addSubview(agreementLb)
        addSubview(freeInfoView)
        freeInfoView.addSubview(freeBGIV)
        freeInfoView.addSubview(freeContentLb)
        
        checkBtn.isHidden = true
        agreementLb.isHidden = true
        payAndBindBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
        
        agreementLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(payAndBindBtn.snp.top).offset(-20)
        }
        checkBtn.snp.makeConstraints { make in
            make.centerY.equalTo(agreementLb)
            make.right.equalTo(agreementLb.snp.left).offset(-8)
        }
        
        freeInfoView.snp.makeConstraints { make in
            make.right.equalTo(wScale(-13))
            make.bottom.equalTo(payAndBindBtn.snp.top).offset(10)
        }
        freeBGIV.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(0)
        }
        freeContentLb.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualTo(0)
        }
    }
    
    lazy var freeInfoView: UIView = {
        UIView()
    }()
    
    lazy var freeBGIV: UIImageView = {
        UIImageView().then {
            if let bg = UIImage(named: "tiyan.qipao") {
                $0.image = bg.resizableImage(withCapInsets: .init(top: 10, left: 40, bottom: 10, right: 40), resizingMode: .stretch)
            }
        }
    }()
    lazy var freeContentLb: UILabel = {
        UILabel().then {
            $0.textColor = .kAlert3
            $0.textAlignment = .center
            $0.text = "体验活动专属福利"
            $0.font = .kScale(13,weight: .bold)
        }
    }()
    
    lazy var payAndBindBtn: UIButton = {
        UIButton(type: .custom).then {
            $0.setTitle("绑定并支付", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
//            $0.addTarget(self, action: #selector(payAndBindClick), for: .touchUpInside)
        }
    }()
    
    lazy var checkBtn = {
        UIButton().then {
            $0.setImage(UIImage(named: "checkbox_normal"), for: .normal)
            $0.setImage(UIImage(named: "checkbox_select"), for: .selected)
            $0.addTarget(self, action: #selector(changeCheckBox), for: .touchUpInside)
        }
    }()
    
    ///协议
    lazy var agreementLb: UILabel = {
        UILabel().then {
            $0.text = "使用本服务需您同意《用户合作协议》"
            $0.textColor = UIColor("#4371FF")
            $0.font = .kScale(12)
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAgreement)))
        }
    }()
}

