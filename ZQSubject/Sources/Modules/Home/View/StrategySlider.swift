
import UIKit
import Then


class StrategySlider: UIView {
    var progress: CGFloat = 0.0 {
        didSet {
           update()
        }
    }
 
    private let ongl: CAGradientLayer = .init()
    private let gl: CAGradientLayer = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(self.gl)
        layer.addSublayer(self.ongl)
        self.on {
            $0.colors = [UIColor(0xFFCF0F).cgColor,UIColor(0xFFEA39).cgColor]
            $0.startPoint = .zero
            $0.endPoint = .init(x: 1, y: 1)
            $0.locations = [0, 1]
        }.off {
            $0.colors = [UIColor(0x83AFFF).cgColor,UIColor(0x5288FF).cgColor]
            $0.startPoint = .zero
            $0.endPoint = .init(x: 1, y: 1)
            $0.locations = [0, 1]
        }
    }
    
    func update() {
        ongl.frame = self.bounds.with({ $0.size.width = self.bounds.width * progress })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func on(_ call: (CAGradientLayer) -> Void ) -> Self {
        call(ongl)
        return self
    }
    
    @discardableResult
    func off(_ call: (CAGradientLayer) -> Void ) -> Self {
        call(gl)
        return self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ongl.frame = self.bounds.with({ $0.size.width = self.bounds.width * progress })
        gl.frame = self.bounds
    }
}

