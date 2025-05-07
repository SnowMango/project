
import UIKit
import Then

class InsetLabel: UILabel {
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        super.intrinsicContentSize.with {
            $0.width += contentInsets.left + contentInsets.right
            $0.height += contentInsets.top + contentInsets.bottom
        }
    }
}
