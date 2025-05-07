
import UIKit
import Then

class SeparatorView: RadiusView {
    
    var separatorColor: UIColor? =  UIColor("#EFEFEF"){
        didSet{
            self.separator.backgroundColor = separatorColor
        }
    }
    var separatorInsets: UIEdgeInsets = .init(top: 0, left: wScale(14), bottom: 0, right: wScale(14)) {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(separator)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSeparator()
        bringSubviewToFront(self.separator)
    }
    
    
    override func updateConstraints() {
        separatorLayout()
        super.updateConstraints()
    }
    
    func separatorLayout() {
        self.separator.snp.remakeConstraints { make in
            make.left.equalTo(separatorInsets.left)
            make.right.equalTo(-separatorInsets.right)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    func updateSeparator() {
        guard let indexPath = indexPath() else { return }
        self.separator.isHidden = indexPath.count == indexPath.index + 1
    }
        
    private lazy var separator: UIView = {
        UIView().then {
            $0.backgroundColor = separatorColor
            $0.layer.cornerRadius = 0.25
        }
    }()
}
