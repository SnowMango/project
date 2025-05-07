
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
        if indexPath.index == 0  && indexPath.count == indexPath.index + 1 {
            view.corner(byRoundingCorners: .allCorners, radii: self.radius() )
        }else if indexPath.index == 0 {
            view.corner(byRoundingCorners: [.topLeft, .topRight], radii: self.radius() )
        }else if indexPath.count == indexPath.index + 1 {
            view.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: self.radius() )
        }else{
            view.corner(byRoundingCorners: .allCorners, radii: 0)
        }
    }
}

class RadiusView: UIView {
    var index: Int = 0
    var count: Int = 1
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutRadius()
    }
}

extension RadiusView: SectionRadiusProtocol {
    func indexPath() -> RadiusIndex? {
        (index, count)
    }
}
