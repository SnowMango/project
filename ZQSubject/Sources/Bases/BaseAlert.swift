import UIKit

///弹窗基类
class BaseAlert: UIView {
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
}

