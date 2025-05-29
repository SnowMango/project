import UIKit

///启动图隐私协议界面,在启动图结束后即显示这个界面
class PrivacyVC: BaseViewController {
    
    // MARK: - lazy load
    lazy var bgView: UIView = {
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(bgView)
        return bgView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = wScale(16)
        view.clipsToBounds = true
        bgView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(wScale(45.5))
        }
        let img = UIImageView(image: UIImage(named: "alert_bg"))
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kBoldScale(19)
        label.textAlignment = .center
        label.text = "隐私政策"
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .kScale(14)
        label.textColor = .kText2
        let attributeStr = NSMutableAttributedString(string:
                                                        "我们非常重视用户个人信息和隐私权的保护，请您在使用我们的产品或服务前认真阅读并确认充分理解隐私政策及用户协议，以便您做出您认为适当的选择。点击“同意”及表示您已阅读、充分理解并同意《用户服务协议》、《隐私协议》的所有条款，我们将尽全力保护您的个人信息安全。")
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.kTheme, range: NSMakeRange(90, 15))
    
        label.attributedText = attributeStr
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProtocolAction(_:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .kBoldScale(17)
        btn.backgroundColor = .kTheme
        btn.addTarget(self, action: #selector(taps), for: .touchUpInside)
        btn.setTitle("同意协议", for: .normal)
        btn.layer.cornerRadius = wScale(21.5)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        btn.backgroundColor = nil
        return btn
    }()
    
    lazy var closeBtn2: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        btn.setTitle("不同意并退出", for: .normal)
        btn.setTitleColor(.kText1, for: .normal)
        btn.titleLabel?.font = .kScale(14)
        btn.backgroundColor = nil
        return btn
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //隐藏导航栏
        hiddenNavigationBarWhenShow = true
        
        let imgview = UIImageView(image: UIImage(named: "launch"))
        imgview.contentMode = .scaleAspectFill
        view.addSubview(imgview)
        imgview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setupUI()
    }
    
    
    func setupUI() {
        
        let bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeBtn)
        contentView.addSubview(contentLabel)
        contentView.addSubview(actionBtn)
        contentView.addSubview(closeBtn2)
  

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(wScale(19))
            make.height.equalTo(wScale(17))
            make.centerX.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(wScale(12))
            make.width.height.equalTo(wScale(15))
        }
        //处理上下多出一段空白
        let size = contentLabel.sizeThatFits(CGSize(width: wScale(244), height: CGFloat(MAXFLOAT)))
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(wScale(14.5))
            make.centerX.equalToSuperview()
            make.size.equalTo(size)
        }
        actionBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(wScale(10.5))
            make.centerX.equalToSuperview()
            make.width.equalTo(wScale(180))
            make.height.equalTo(wScale(43))
        }
  
        
        closeBtn2.snp.makeConstraints { (make) in
            make.top.equalTo(actionBtn.snp.bottom).offset(wScale(9))
            make.centerX.equalToSuperview()
            make.width.equalTo(actionBtn)
            make.height.equalTo(wScale(13.5))
            make.bottom.equalToSuperview().offset(wScale(-8))
        }
    }
    
    ///确定
    @objc func taps() {
        kUserDefault.setValue("agree", forKey: UserDefaultKey.isAgreeProtocol.rawValue)
        Router.shared.route(.firstGuide)
    }
    
    ///关闭
    @objc func closeTap() {
        exit(0)
    }
    
    ///点击政策
    @objc func tapProtocolAction(_ sender: UITapGestureRecognizer) {
        
        
        guard let protocolLabel = sender.view as? UILabel else { return }
        
        if sender.didTapAttributedTextInLabel(label: protocolLabel, inRange: NSRange(location: 90, length: 8)) {
            AppLink.serviceTerms.routing()
            
        } else if sender.didTapAttributedTextInLabel(label: protocolLabel, inRange: NSRange(location: 99, length: 6)) {
            AppLink.privacyTerms.routing()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
