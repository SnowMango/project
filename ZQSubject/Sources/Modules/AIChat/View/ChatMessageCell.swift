
import UIKit
import Then

class ChatMessageCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(with message: ChatMessage) {
        let sending: Bool = message.role == .user
        itemView.sending = sending
        itemView.bubbleColor = sending ? .kTheme:.white
        contentLb.textColor = sending ? .white:UIColor(0x161A23)
        contentLb.text = message.content
    }

    func makeUI() {
        addSubview(itemView)
        let width = SCREEN_WIDTH - wScale(16)*2 - 1
        itemView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
            make.width.equalTo(width).priority(.high)
        }
        
        itemView.addContentView(contentLb)
        contentLb.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    lazy var itemView: ChatMessageItem = {
        ChatMessageItem().then {
            $0.sending = true
        }
    }()
    
    lazy var contentLb: UILabel = {
        UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.numberOfLines = 0
        }
    }()
    
}


