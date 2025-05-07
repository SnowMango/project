
import UIKit

class IconLabel: UIView {
    
    var titleLabel: UILabel = UILabel()
    var iconImageView: UIImageView = UIImageView()
    
    var spacing: CGFloat = 5 {
        didSet {
            self.stack.spacing = self.spacing
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(self.stack)
        self.stack.addArrangedSubview(self.iconImageView)
        self.stack.addArrangedSubview(self.titleLabel)
        self.stack.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    lazy var stack: UIStackView = {
        return UIStackView().then {
            $0.spacing = self.spacing
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }()
    
}
