
import UIKit
import Then

class RadiusCollectionCell: UICollectionViewCell, SectionRadiusProtocol {
   
    enum SeparatorStyle {
        case none
        case line
    }
    
    var separatorStyle: RadiusCollectionCell.SeparatorStyle = .line {
        didSet {
            updateSeparator()
        }
    }
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
        layoutRadius()
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
        if self.separatorStyle == .none {
            self.separator.isHidden = true
            return
        }
        guard let collection = self.superview as? UICollectionView  else {
            return
        }
        guard let indexPath = collection.indexPath(for: self) else {
            return
        }
        let max = collection.numberOfItems(inSection: indexPath.section)
        self.separator.isHidden = max == indexPath.row + 1

    }
    
    private lazy var separator: UIView = {
        UIView().then {
            $0.backgroundColor = separatorColor
            $0.layer.cornerRadius = 0.25
        }
    }()
    
    func indexPath() -> RadiusIndex? {
        guard let collection = self.superview as? UICollectionView  else {
            return nil
        }
        guard let indexPath = collection.indexPath(for: self) else {
            return nil
        }
        let max = collection.numberOfItems(inSection: indexPath.section)
        return (indexPath.row, max)
    }
    
    func radiusView() -> UIView {
        return self.contentView
    }
    
}
