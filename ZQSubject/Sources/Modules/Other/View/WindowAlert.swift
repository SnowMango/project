import UIKit
import Kingfisher

enum AlertType {
    ///单个按钮
    case sigle
    ///确认、取消按钮
    case double
    ///图片弹窗
    case image
    ///加入社群
    case join
}

class WindowAlert: UIView {
    
    // MARK: - lazy load
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = wScale(18)
        view.clipsToBounds = true
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(wScale(35))
            make.right.equalToSuperview().offset(-wScale(35))
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kBoldFontScale(20)
        label.textColor = .kText2
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: wScale(14))
        label.textColor = .kText2
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: wScale(16))
        btn.backgroundColor = .kTheme
        btn.addTarget(self, action: #selector(taps), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.addTapGesture(self, sel: #selector(imageViewTap))
        return img
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: wScale(16))
        btn.backgroundColor = .kTheme_grey
        btn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        return btn
    }()
    
    lazy private var serviceOnlineLb: UILabel = {
        return UILabel()
    }()
    
    lazy private var servicePhoneNumLb: UILabel = {
        return UILabel()
    }()
    
    ///记录弹窗类型
    private(set) var alertType: AlertType = .sigle
    
    ///确认回调
    var doneCallBack: (()->())?
    ///关闭回调
    var closeCallBack: (()->())?
    ///点击图片的回调
    var imageViewCallBack: (()->())?
    
    ///升级链接
    var upUrl: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /// 初始化方法
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - alertType: 弹框类型，默认单一按钮
    init(title: String = "", content: String = "", url: String? = nil, actionTitle: String? = nil, closeTitle: String? = nil, alertType: AlertType = .sigle) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        upUrl = url
        self.alertType = alertType
        setupUI(type: alertType, title: title, content: content, actionTitle: actionTitle, closeTitle: closeTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self))_deinit")
    }
}

//MARK: - UI
extension WindowAlert {
    ///展示
    func show(animate: Bool = true) {
        if let views = UIApplication.shared.keyWindow?.subviews {
            for ele in views {
                if ele.isKind(of: WindowAlert.self) {
                    ele.removeFromSuperview()
                }
            }
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        guard animate else {
            return
        }
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        layoutIfNeeded()
    }
    
    ///移除
    func remove(_ finish: (()->())?) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        }completion: { (_) in
            self.removeFromSuperview()
            finish?()
        }
    }
    
    func setHidden(_ hide: Bool, _ finish: (() -> ())?) {
        if hide && alpha == 0 {
            finish?()
            return
        }
        if !hide && alpha == 1 {
            finish?()
            return
        }
        let newAlpha: CGFloat = hide ? 0 : 1
        UIView.animate(withDuration: 0.25) {
            self.alpha = newAlpha
        } completion: { (_) in
            finish?()
        }
    }
    
    private func setupUI(type: AlertType, title: String?, content: String?, actionTitle: String?, closeTitle: String?) {
        
        switch type {
        case .sigle:
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            contentView.addSubview(contentLabel)
            contentLabel.textAlignment = .left
            contentLabel.text = content
            contentView.addSubview(actionBtn)
            actionBtn.titleLabel?.font = .kBoldFontScale(17)
            actionBtn.setTitle(actionTitle ?? "确定", for: .normal)
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(wScale(25))
                make.centerX.equalToSuperview()
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(wScale(14))
                make.left.equalToSuperview().offset(wScale(23))
                make.right.equalToSuperview().offset(wScale(-23))
                make.height.lessThanOrEqualTo(wScale(160))
            }
            actionBtn.snp.makeConstraints { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(wScale(24))
                make.centerX.equalToSuperview()
                make.height.equalTo(wScale(44))
                make.width.equalTo(wScale(200))
                make.bottom.equalToSuperview().inset(wScale(28))
            }
          
            actionBtn.setNeedsLayout()
            actionBtn.layoutIfNeeded()
            actionBtn.backgroundColor = .kTheme
            actionBtn.layer.cornerRadius = wScale(8)
            actionBtn.layer.masksToBounds = true
            
        case .double:
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            contentView.addSubview(contentLabel)
            contentLabel.textAlignment = .left
            contentLabel.text = content
            contentView.addSubview(actionBtn)
            actionBtn.titleLabel?.font = .kBoldFontScale(17)
            actionBtn.setTitle(actionTitle ?? "确定", for: .normal)
            contentView.addSubview(closeBtn)
            closeBtn.titleLabel?.font = .kFontScale(17)
            closeBtn.setTitle(closeTitle ?? "取消", for: .normal)
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(wScale(25))
                make.centerX.equalToSuperview()
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(wScale(14))
                make.left.equalToSuperview().offset(wScale(23))
                make.right.equalToSuperview().offset(wScale(-23))
                make.height.lessThanOrEqualTo(wScale(160))
            }
            closeBtn.snp.makeConstraints { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(wScale(24))
                make.left.equalToSuperview().offset(wScale(18))
                make.height.equalTo(wScale(43))
                make.bottom.equalToSuperview().inset(wScale(28))
            }
            closeBtn.setTitleColor(.kText2, for: .normal)
            closeBtn.backgroundColor = UIColor("DDE8FB")
            closeBtn.layer.cornerRadius = wScale(21.5)
            closeBtn.layer.masksToBounds = true
            actionBtn.snp.makeConstraints { (make) in
                make.top.width.height.equalTo(closeBtn)
                make.left.equalTo(closeBtn.snp.right).offset(wScale(14))
                make.right.equalToSuperview().inset(wScale(18))
            }
            actionBtn.setNeedsLayout()
            actionBtn.layoutIfNeeded()
            actionBtn.backgroundColor = .kTheme
            actionBtn.layer.cornerRadius = wScale(21.5)
            actionBtn.layer.masksToBounds = true
            return
        case .image:
            contentView.backgroundColor = nil
            
            
            contentView.addSubview(closeBtn)
            closeBtn.backgroundColor = nil
            closeBtn.setImage(UIImage(named:"close.white"), for: .normal)
            closeBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(wScale(28))
                make.top.right.equalTo(0)
            }
            
            contentView.addSubview(imageView)
            imageView.layer.cornerRadius = wScale(18)
            imageView.kf.setImage(with: URL(string: upUrl ?? ""))
            imageView.layer.masksToBounds = true
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(closeBtn.snp.bottom).offset(wScale(5))
                make.centerX.equalToSuperview()
                make.width.equalTo(wScale(307))
                make.height.equalTo(wScale(470))
                make.bottom.lessThanOrEqualTo(0)
            }
            
        case .join:
            let bgImgv = UIImageView(image: UIImage(named: "pop_window_bg"))
            contentView.addSubview(bgImgv)
            contentView.backgroundColor = .clear
            contentView.addSubview(imageView)
            contentView.addSubview(closeBtn)
            contentView.addSubview(titleLabel)
            contentView.addSubview(contentLabel)
            imageView.kf.setImage(with: URL(string: upUrl ?? ""))
            imageView.layer.cornerRadius = wScale(10)
            imageView.layer.masksToBounds = true
            bgImgv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            titleLabel.text = title
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(wScale(19))
                make.centerX.equalToSuperview()
            }
            closeBtn.setImage(UIImage(named: "close.white"), for: .normal)
            closeBtn.backgroundColor = .clear
            closeBtn.snp.makeConstraints { make in
                make.width.height.equalTo(wScale(40))
                make.top.equalToSuperview().offset(wScale(10))
                make.right.equalToSuperview().inset(wScale(5))
            }
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(wScale(163.5))
                make.top.equalTo(titleLabel.snp.bottom).offset(wScale(14))
                make.centerX.equalToSuperview()
            }
            contentLabel.text = content
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(wScale(17))
                make.centerX.equalToSuperview()
//                make.bottom.equalToSuperview().inset(wScale(25))
            }
            contentView.addSubview(actionBtn)
            actionBtn.titleLabel?.font = .kBoldFontScale(17)
            actionBtn.setTitle(actionTitle ?? "确定", for: .normal)
            actionBtn.snp.makeConstraints { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(wScale(14))
                make.width.equalTo(wScale(280))
                make.height.equalTo(wScale(43))
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(wScale(25))
            }
            actionBtn.setNeedsLayout()
            actionBtn.layoutIfNeeded()
            actionBtn.backgroundColor = .kTheme
            actionBtn.layer.cornerRadius = wScale(21.5)

        }
    }
}

//MARK: - Action
extension WindowAlert {
    
    @objc private func imageViewTap() {
        remove {[weak self] in
            self?.imageViewCallBack?()
        }
    }
    
    ///确定
    @objc func taps() {
        remove {[weak self] in
            self?.doneCallBack?()
        }
    }
    
    ///关闭
    @objc func closeTap() {
        remove {[weak self] in
            self?.closeCallBack?()
        }
    }
    
    //升级跳转路由
    static func upgradeRoute(_ urlString: String) {
        switch urlString {
        case let str where str.hasPrefix("https"):
            //跳到App Store
            guard let httpsURL = URL(string: urlString) else { return }
            UIApplication.shared.open(httpsURL, options: [:], completionHandler: nil)
        default:
            //TF安装
            guard let itmsURL = URL(string: "itms-beta://\(urlString)"),
                  let httpsURL = URL(string: "https://\(urlString)") else { return }
            //判断能不能打开TF,如果不能打开的话就走https的链接
            if UIApplication.shared.canOpenURL(itmsURL) {
                //TF已经安装但是没有打开的情况下,走这个的话会打开TF,而且可以拉起安装"有财"的授权.
                UIApplication.shared.open(itmsURL, options: [:], completionHandler: nil)
            } else {
                //不能一开始就走https的链接,因为如果TF已经安装但是没有打开的情况下,走这个的话会打开TF,但是没办法拉起安装"有财"的授权.
                UIApplication.shared.open(httpsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    ///跳到系统通知页面
    @objc func goSystemNotifications() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            closeTap()
        }
    }
    
}
