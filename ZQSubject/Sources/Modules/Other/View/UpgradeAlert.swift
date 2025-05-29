import UIKit

///升级弹窗
class UpgradeAlert: BaseAlert {
    // MARK: - lazy load
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = wScale(18)
        view.clipsToBounds = true
        
        let img = UIImageView(image: UIImage(named: "alert_bg"))
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "upgrade"))
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kBoldScale(20)
        label.textColor = .kText2
    
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: wScale(14))
        label.textColor = .kText2
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .kBoldScale(17)
        btn.backgroundColor = .kTheme
        btn.addTarget(self, action: #selector(taps), for: .touchUpInside)
        btn.layer.cornerRadius = wScale(21.5)
        btn.layer.masksToBounds = true
        btn.setTitle("立即升级", for: .normal)
        return btn
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.kText2, for: .normal)
        btn.titleLabel?.font = .kBoldScale(17)
        btn.backgroundColor = UIColor("#DDE8FB")
        btn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        btn.layer.cornerRadius = wScale(21.5)
        btn.layer.masksToBounds = true
        btn.setTitle("暂不升级", for: .normal)
        return btn
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .kScale(12)
        label.textColor = UIColor("#858585")
        label.textAlignment = .center
        return label
    }()
    
    ///确认回调
    var doneCallBack: (()->())?
    ///关闭回调
    var closeCallBack: (()->())?
    
    var model: VersionInfo
    init(model: VersionInfo) {
        self.model = model
        super.init(frame: CGRect.zero)
        setupUI()
//        titleLabel.text = model.appTitle
        titleLabel.text = "新版本升级"
        contentLabel.text = model.upgradeMessage
 
        let verString = model.versionName
        versionLabel.text = "版本号:V\(kAppVersion)>>V\(verString)"

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(contentView)
        addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(actionBtn)
        contentView.addSubview(closeBtn)
        contentView.addSubview(versionLabel)
         
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(wScale(45))
            make.right.equalToSuperview().offset(-wScale(45))
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(wScale(-25))
            make.right.equalTo(contentView.snp.right).inset(wScale(11))
            make.width.equalTo(wScale(112))
            make.height.equalTo(wScale(99.5))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(wScale(32))
            make.left.equalToSuperview().inset(wScale(25))
            make.height.equalTo(wScale(19))
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(wScale(16))
            make.left.right.equalToSuperview().inset(wScale(25))
        }
        
        if model.isForceUpgrade == 1 {
            //强制升级
            actionBtn.snp.makeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(wScale(18))
                make.width.equalTo(wScale(180))
                make.height.equalTo(wScale(43))
                make.centerX.equalToSuperview()
            }
            
        } else {
            //建议升级
            closeBtn.snp.makeConstraints { make in
                make.top.equalTo(contentLabel.snp.bottom).offset(wScale(18))
                make.width.equalTo(wScale(117))
                make.height.equalTo(wScale(43))
                make.left.equalToSuperview().inset(wScale(18))
            }
            
            actionBtn.snp.makeConstraints { make in
                make.top.size.equalTo(closeBtn)
                make.right.equalToSuperview().inset(wScale(18))
            }
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(actionBtn.snp.bottom).offset(wScale(8))
            make.centerX.equalToSuperview()
            make.height.equalTo(wScale(11))
            make.bottom.equalToSuperview().inset(wScale(17.5))
        }
        
    }
}

extension UpgradeAlert {
    @objc func taps() {
        //跳到App Store
        guard let path = model.downloadAddressUrl, let url: URL = URL(string: path) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        remove {[weak self] in
            self?.doneCallBack?()
        }
    }
    
    @objc func closeTap() {
        remove {[weak self] in
            self?.closeCallBack?()
        }
    }
}

