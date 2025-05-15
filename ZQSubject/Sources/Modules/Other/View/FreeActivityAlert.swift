
import UIKit
import Kingfisher

class FreeActivityAlert: UIView {
    typealias CallbackBlock = () -> Void
    // MARK: - lazy load
    lazy var contentView: UIView = {
        return UIView()
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    lazy var actionBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(UIColor("#FFF1A9"), for: .normal)
            $0.titleLabel?.font = .kScale(22, weight: .medium)
            $0.setBackgroundImage(UIImage(named: "red.yellow.btn.bg"), for: .normal)
            $0.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        }
    }()
    
    lazy var moreBtn: UIButton = {
        UIButton().then {
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16, weight: .heavy)
            $0.addTarget(self, action: #selector(moreTap), for: .touchUpInside)
        }
    }()
    
    lazy var closeBtn: UIButton = {
        UIButton().then {
            $0.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
            $0.setImage(UIImage(named:"close.white"), for: .normal)
        }
    }()
    
    lazy var moreBaseLineView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
        }
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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    ///关闭
    @objc func actionTap() {
        self.moreBlock = nil
        self.closeBlock = nil
        if let block = self.actionBlock {
            self.remove {
                block()
            }
            return
        }
        self.remove(nil)
    }
    
    @objc func moreTap() {
        self.actionBlock = nil
        self.closeBlock = nil
        if let block = self.moreBlock {
            self.remove {
                block()
            }
            return
        }
        self.remove(nil)
    }
    
    @objc func closeTap() {
        self.actionBlock = nil
        self.moreBlock = nil
        if let block = self.closeBlock {
            self.remove {
                block()
            }
            return
        }
        self.remove(nil)
    }
    
    private var actionBlock: CallbackBlock?
    private var moreBlock: CallbackBlock?
    private var closeBlock: CallbackBlock?
    
    /// 初始化方法
    init(url: String,
         actionTitle: String? = nil, moreTitle: String? = nil,
         actionBlock: CallbackBlock?,
         moreBlock: CallbackBlock?,
         closeBlock: CallbackBlock?) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .black.withAlphaComponent(0.6)
        setupUI()
        setupLayout()
        
        imageView.kf.setImage(with: URL(string: url))
        actionBtn.isHidden = actionTitle == nil
        actionBtn.setTitle(actionTitle, for: .normal)
        
        moreBtn.isHidden = moreTitle == nil
        moreBtn.setTitle(moreTitle, for: .normal)
        moreBaseLineView.isHidden = moreBtn.isHidden
        self.actionBlock = actionBlock
        self.moreBlock = moreBlock
        self.closeBlock = closeBlock
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(closeBtn)
        contentView.addSubview(imageView)
       
        contentView.addSubview(actionBtn)
        contentView.addSubview(moreBtn)
        contentView.addSubview(moreBaseLineView)
    }
    
    func setupLayout() {
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(35))
        }

        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(wScale(28))
            make.top.right.equalTo(0)
        }

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(wScale(5))
            make.centerX.equalToSuperview()
            make.width.equalTo(wScale(307))
            make.height.equalTo(wScale(470))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(wScale(25))
            make.centerX.equalToSuperview()
            make.width.equalTo(wScale(205))
            make.height.equalTo(wScale(66))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(actionBtn.snp.bottom).offset(wScale(12))
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        }
        
        moreBaseLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(moreBtn)
            make.height.equalTo(1)
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
extension FreeActivityAlert {
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
