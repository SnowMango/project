import UIKit

extension UIFont {
    
    static func kBoldScale(_ f: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: wScale(f))
    }
    
    static func kScale(_ size: CGFloat, weight:UIFont.Weight = .regular) -> UIFont {
        .systemFont(ofSize: wScale(size), weight: weight)
    }
}
