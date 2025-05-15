
import UIKit

class HumanAlert: UIView {
    typealias CallbackBlock = () -> ()
    // MARK: - lazy load
    lazy var contentView: UIView = {
        UIView().then {
            $0.backgroundColor = .white
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#252525")
            $0.font = .kScale(16, weight: .bold)
            $0.text = "安全验证"
        }
    }()
    
    lazy var humanSlider: HumanSlider = {
        HumanSlider()
    }()
    
    lazy var closeBtn: UIButton = {
        UIButton().then {
            $0.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
            $0.setImage(UIImage(named:"close.mini"), for: .normal)
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
    func actionTap() {
        self.closeBlock = nil
        if let block = self.actionBlock {
            self.remove {
                block()
            }
            return
        }
        self.remove(nil)
    }
    
    @objc func closeTap() {
        self.actionBlock = nil
        if let block = self.closeBlock {
            self.remove {
                block()
            }
            return
        }
        self.remove(nil)
    }
    
    private var actionBlock: CallbackBlock?
    private var closeBlock: CallbackBlock?
    
    /// 初始化方法
    init(action actionBlock: CallbackBlock?,
         close closeBlock: CallbackBlock?) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .black.withAlphaComponent(0.6)
        setupUI()
        setupLayout()
        self.actionBlock = actionBlock
        self.closeBlock = closeBlock
    }
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(closeBtn)
        contentView.addSubview(titleLb)
        contentView.addSubview(humanSlider)
        humanSlider.successfully = { [weak self] in
            self?.actionTap()
        }
    }
    
    func setupLayout() {
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(wScale(20))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(wScale(28))
            make.top.equalTo(5)
            make.right.equalTo(-5)
        }
        
        titleLb.snp.makeConstraints { (make) in
            make.top.left.equalTo(wScale(24))
        }
        
        humanSlider.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(wScale(40))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(24))
            make.bottom.lessThanOrEqualTo(wScale(-40))
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
extension HumanAlert {
    ///展示
    func show(to view: UIView? = nil, animate: Bool = true) {
        var sv: UIView? = UIApplication.shared.keyWindow
        if let view = view {
            sv = view
        }
        guard let sv = sv else { return }
        for e in sv.subviews  {
            if let _ = e as? Self {
                e.removeFromSuperview()
            }
        }
        sv.addSubview(self)
        self.frame = sv.bounds
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
