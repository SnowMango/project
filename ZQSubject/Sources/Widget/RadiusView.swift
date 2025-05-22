
import UIKit

typealias RadiusIndex = (index:Int, count:Int)

protocol SectionRadiusProtocol {
    func indexPath() -> RadiusIndex?
    func radiusView() -> UIView
    func radius() -> CGFloat
}
extension SectionRadiusProtocol {
    func radius() -> CGFloat {
        wScale(10)
    }
}
extension SectionRadiusProtocol where Self:UIView {
    func radiusView() -> UIView {
        self
    }
}

extension SectionRadiusProtocol {
    
    func layoutRadius() {
        guard let indexPath = indexPath() else { return }
        let view = radiusView()
        let r = self.radius()
        if r == 0 {
            view.corner(byRoundingCorners: .allCorners, radii: 0)
            return
        }
        if indexPath.index == 0  && indexPath.count == indexPath.index + 1 {
            view.corner(byRoundingCorners: .allCorners, radii: r )
        }else if indexPath.index == 0 {
            view.corner(byRoundingCorners: [.topLeft, .topRight], radii: r)
        }else if indexPath.count == indexPath.index + 1 {
            view.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: r)
        }else{
            view.corner(byRoundingCorners: .allCorners, radii: 0)
        }
    }
}

class RadiusView: UIView {
    var index: Int = 0
    var count: Int = 1
    
    var autoRadius: CGFloat = wScale(10) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @discardableResult
    func gradient(_ call: (CAGradientLayer) -> Void) -> Self {
        if let ls = self.layer.sublayers, ls.contains(bggl) {
            call(bggl)
            return self
        }
        self.layer.addSublayer(bggl)
        call(bggl)
        return self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutRadius()
        if let sl = bggl.superlayer {
            sl.insertSublayer(bggl, at: 0)
            bggl.frame = self.bounds
        }
    }
    
    private lazy var bggl: CAGradientLayer = {
        CAGradientLayer()
    }()
}

extension RadiusView: SectionRadiusProtocol {
    func indexPath() -> RadiusIndex? {
        (index, count)
    }
    
    func radius() -> CGFloat {
        self.autoRadius
    }
}
