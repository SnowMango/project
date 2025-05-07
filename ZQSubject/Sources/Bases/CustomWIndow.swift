
import UIKit
import MBProgressHUD

class CustomWindow: UIWindow {
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        var hud: MBProgressHUD?
        for sub in subviews {
            if sub is MBProgressHUD {
                hud = sub as? MBProgressHUD
            }
        }
        if let h = hud {
            bringSubviewToFront(h)
        }
    }
}


