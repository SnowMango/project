
import UIKit

class StrategyAlert: UIView {
    enum AlertType {
        case success
        case failure
        case info
    }
    // MARK: - lazy load
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = wScale(18)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kScale(19, weight: .medium)
        label.textColor = UIColor("#252525")
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .kScale(15, weight: .medium)
        label.textColor = UIColor("#252525")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .kScale(13, weight: .medium)
        label.textColor = UIColor("#989898")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .kScale(15, weight: .medium)
        btn.backgroundColor = .kTheme
        btn.layer.cornerRadius = wScale(8)
        btn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        return btn
    }()
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            if !CGRectContainsPoint(self.contentView.frame, loc){
                self.closeTap()
                return
            }
            super.touchesBegan(touches, with: event)
        }
    }
    
    ///记录弹窗类型
    private(set) var alertType: StrategyAlert.AlertType = .info
    
    ///确认回调
    var doneCallBack: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    ///关闭
    @objc func closeTap() {
        remove {[weak self] in
            self?.doneCallBack?()
        }
    }
    
    /// 初始化方法
    /// - Parameters:
    ///   - title: 标题
    ///   - content: 内容
    ///   - alertType: 弹框类型，默认单一按钮
    init(title: String?, content: String?, desc: String?, alertType: AlertType = .info, closeTitle: String? = nil, doneCallBack: (()->())?) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .black.withAlphaComponent(0.6)
        setupUI()
        setupLayout()
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.descLabel.text = desc
        if let closeTitle = closeTitle {
            self.closeBtn.setTitle(closeTitle, for: .normal)
        }else {
            self.closeBtn.setTitle("我知道了", for: .normal)
        }
        switch alertType {
        case .success:
            self.imageView.image = UIImage(named: "alert.success")
        case .failure:
            self.imageView.image = UIImage(named: "alert.error")
        case .info:
            self.imageView.image = UIImage(named: "alert.info")
        }
        self.doneCallBack = doneCallBack
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(closeBtn)
    }
    
    func setupLayout() {
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(35))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(wScale(14))
            make.top.equalTo(wScale(35))
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(wScale(27))
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(wScale(14))
            make.top.equalTo(imageView.snp.bottom).offset(wScale(15))
            
        }
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(wScale(14))
            make.top.equalTo(contentLabel.snp.bottom).offset(wScale(10))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(wScale(26))
            make.bottom.equalTo(wScale(-30))
            make.width.equalTo(wScale(200))
            make.height.equalTo(wScale(44))
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self))_deinit")
    }
}

//MARK: - UI
extension StrategyAlert {
    ///展示
    func show(animate: Bool = true) {
        if let views = UIApplication.shared.keyWindow?.subviews {
            for ele in views {
                if ele.isKind(of: Self.self) {
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

}
