
import UIKit
import Then
import Kingfisher

///新手指南
class LevitateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private var start: CGAffineTransform = .identity
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var item: AppResource.ResourceData?
    private var insets: UIEdgeInsets = UIEdgeInsets(top: 40, left: 10, bottom: 20, right: 10)
    @objc func showLink() {
        guard let item = self.item else {
            return
        }
        JumpManager.jumpToWeb(item.linkAddress)
    }

    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        guard let pv = pan.view else { return }
        guard let superview = superview else { return }
        let enbaleFrame = superview.bounds.inset(by: superview.safeAreaInsets).inset(by: self.insets)
        if pan.state == .began {
            self.start =  pv.transform
            return
        }
        let translate = pan.translation(in: pv)
        let willTo = self.start.translatedBy(x: translate.x, y: translate.y)
       
        let willFrame = pv.frame.applying(pv.transform.inverted()).applying(willTo)
        if pan.state != .changed {
            let bounces = self.bounces(willFrame, in: enbaleFrame)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
                pv.transform = willTo.translatedBy(x: bounces.x, y: bounces.y)
            })
            return
        }
        let damping = self.damping(willFrame, in: enbaleFrame)
        pv.transform = willTo.translatedBy(x: damping.x, y: damping.y)
    }

    private func bounces(_ frame: CGRect, in enable:CGRect) -> CGPoint {
        var offset: CGPoint = .zero
        if frame.midX < enable.midX {
            offset.x = enable.minX - frame.minX
        }else {
            offset.x = enable.maxX - frame.maxX
        }
        
        if frame.minY < enable.minY {
            offset.y = enable.minY - frame.minY
        } else  if frame.maxY > enable.maxY {
            offset.y = enable.maxY -  frame.maxY
        }
        return offset
    }
    
    private func damping(_ frame: CGRect, in enable:CGRect) -> CGPoint {
        let m: CGPoint = CGPoint(x: frame.width, y: frame.height)
        if m.x == 0 || m.y == 0 { return .zero }
        var distance: CGPoint = .zero
        if frame.minX < enable.minX {
            distance.x = enable.minX - frame.minX
        }else if frame.maxX > enable.maxX {
            distance.x = enable.maxX - frame.maxX
        }
        if frame.minY < enable.minY {
            distance.y = enable.minY - frame.minY
        }else if frame.maxY > enable.maxY {
            distance.y = enable.maxX - frame.maxX
        }
    
        var offset: CGPoint = .zero
        if distance.x != 0 {
            offset.x = distance.x - log(1 + abs(distance.x)/m.x) * m.x * distance.x / abs(distance.x)
        }
        if distance.y != 0 {
            offset.y = distance.y - log(1 + abs(distance.y)/m.y) * m.y * distance.y / abs(distance.y)
        }
        return offset
    }
    
    func load(_ data: AppResource.ResourceData? ) {
        self.item = data
        if let item = data {
            imgGuide.kf.setImage(with: item.resourceUrl?.validURL())
        }
    }
    
    private func setupUI() {
        addSubview(imgGuide)
        imgGuide.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLink)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))
    }
    
    private lazy var imgGuide: UIImageView = {
        return UIImageView()
    }()
}
