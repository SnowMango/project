
import UIKit
import Then

class ChatMessageItem: UIView {
    var sending: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    var bubbleColor: UIColor? {
        didSet {
            self.bubbleView.backgroundColor = bubbleColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        bubbleView.position = sending ? .topRight:.topLeft
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        bubbleView.snp.remakeConstraints { make in
            if sending {
                make.right.equalTo(0)
                make.left.greaterThanOrEqualTo(0)
            } else {
                make.left.equalTo(0)
                make.right.lessThanOrEqualTo(0)
            }
            make.top.bottom.equalTo(0)
        }
        super.updateConstraints()
    }
    
    func makeUI() {
        addSubview(bubbleView)
    }

    func addContentView(_ view: UIView) {
        self.bubbleView.addSubview(view)
    }
    
    lazy var bubbleView: BubbleView = {
        BubbleView().then {
            $0.radius = 22.5
        }
    }()
    
}


