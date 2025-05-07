import UIKit

extension UIView {
    func addTapGesture(_ target: Any?, sel: Selector?) {
        let tap = UITapGestureRecognizer(target: target, action: sel)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
}
