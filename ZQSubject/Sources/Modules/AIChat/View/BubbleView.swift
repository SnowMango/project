
import UIKit


class BubbleView: UIView {
    
    enum Position {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    var radius: CGFloat = 0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    var position: BubbleView.Position = .topLeft {
        didSet{
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutRadius()
    }
    
    func layoutRadius() {
        var corners: UIRectCorner = .allCorners
        switch position {
        case .topLeft:
            corners.remove(.topLeft)
        case .topRight:
            corners.remove(.topRight)
        case .bottomLeft:
            corners.remove(.bottomLeft)
        case .bottomRight:
            corners.remove(.bottomRight)
        }
        if radius == 0 {
            corner(byRoundingCorners: corners, radii: 0)
            return
        }
        corner(byRoundingCorners: corners, radii: radius)
    }
}
