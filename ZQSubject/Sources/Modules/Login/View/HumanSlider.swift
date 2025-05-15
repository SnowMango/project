
import UIKit
import Then

///新手指南
class HumanSlider: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    var successfully:(() -> ())?
    
    private var start: CGAffineTransform = .identity
    
    var onColor: UIColor? = UIColor("0x4fe322")
    private var done: Bool = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        guard let pv = pan.view else { return }
        if done { return }
        if pan.state == .began {
            self.start =  pv.transform
            self.titleLb.isHidden = true
            return
        }
        let translate = pan.translation(in: pv)
        let willTo = self.start.translatedBy(x: translate.x, y: 0)
        let enableFame = self.bounds
        let willFrame = pv.frame.applying(pv.transform.inverted()).applying(willTo)
        if pan.state != .changed {
            self.titleLb.isHidden = false
            self.titleLb.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
                pv.transform = .identity
                self.onView.transform = pv.transform
                self.titleLb.alpha = 1
            })
            return
        }
        if canDone(willFrame, in: enableFame) {
            self.done = true
            if let successfully = self.successfully {
                successfully()
                self.successfully = nil
            }
        }
        let bounces = bounces(willFrame, in: enableFame)
        pv.transform = willTo.translatedBy(x: bounces.x, y: bounces.y)
        self.onView.transform = pv.transform
    }
    
    private func canDone(_ frame: CGRect, in enable:CGRect) -> Bool {
        return frame.maxX >= enable.maxX
    }
    
    private func bounces(_ frame: CGRect, in enable:CGRect) -> CGPoint {
        var offset: CGPoint = .zero
        if frame.minX < enable.minX {
            offset.x = enable.minX - frame.minX
        } else  if frame.maxX > enable.maxX {
            offset.x = enable.maxX - frame.maxX
        }
        return offset
    }
    

    private func setupUI() {
        clipsToBounds = true
        backgroundColor = .kBackGround
        addSubview(onView)
        addSubview(sliderIV)
       
        addSubview(titleLb)
        
        onView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.right.equalTo(self.snp.left)
            make.height.width.equalToSuperview()
        }
        
        sliderIV.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        titleLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
        }
        sliderIV.isUserInteractionEnabled = true
        sliderIV.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction)))
    }
    
    private lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#252525")
            $0.font = .kScale(12)
            $0.text = "请按住滑块，拖动到最右边"
        }
    }()
    
    private lazy var onView: UIView = {
        UIView().then {
            $0.backgroundColor = self.onColor
        }
    }()
    
    private lazy var sliderIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "thumb.arrow")
        }
    }()
}
