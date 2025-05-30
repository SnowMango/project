
import UIKit

class EnvManager {
    static let shared = EnvManager()
    private init() {}
    
    private let EnvironmentKey = "AppEnvironmentKey"
    
    func loadEnvironment() -> Environment {
        let local = UserDefaults.standard.integer(forKey: EnvironmentKey)
        if let en = Environment(rawValue: local) {
            return en
        }
        return env
    }
    
    func change(_  en: Environment, reboot: Bool = false) {
        UserDefaults.standard.set(en.rawValue, forKey: EnvironmentKey)
        UserDefaults.standard.synchronize()
        if reboot {
            abort()
        }
    }
    
    func canTest() -> Bool {
#if DEBUG
        return true
#elseif TEST
        return true
#else
        return false
#endif
    }
    
    func showTestUI() {
        guard canTest() else { return }
        let tag = 10086
        guard let window = UIApplication.shared.keyWindow else { return }
        if let view = window.viewWithTag(tag) {
            window.bringSubviewToFront(view)
            return
        }
        let view = TestLevitateView()
        view.tag = tag
        view.load(env)
        window.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.equalTo(view.insets.left)
            make.top.equalTo(view.insets.top)
        }
        view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            view.alpha = 1
        }
    }
    
    func dismissTestUI() {
        let tag = 10086
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let view = window.viewWithTag(tag) else { return }
  
        UIView.animate(withDuration: 0.25) {
            view.alpha = 0
        }completion: { (_) in
            view.removeFromSuperview()
        }
    }
}

import Then
import SnapKit

class TestLevitateView: UIView {
    private var start: CGAffineTransform = .identity
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var insets: UIEdgeInsets = UIEdgeInsets(top: 44, left: 10, bottom: 20, right: 10)
    @objc func showLink() {
        Router.shared.route("change/env")
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

    func load(_ en: Environment) {
        self.titleLb.text = String(en.name().uppercased().first!)
    }
    
    private func setupUI() {
       
        clipsToBounds = true
        addSubview(titleLb)
        backgroundColor = .kTheme
        layer.cornerRadius = wScale(24)
        
        titleLb.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
            make.width.height.equalTo(wScale(48))
        }
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLink)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))
    }
    
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.font = .kScale(30, weight: .bold)
            $0.textAlignment = .center
        }
    }()
}
