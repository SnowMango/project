
import UIKit
import Then
import Kingfisher

class ChatLoadingCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loading(_ show: Bool) {
        itemView.isHidden = !show
        if show {
            if let path = Bundle.main.url(forResource: "message.loading3x", withExtension: "gif") {
                loadingIV.kf.setImage(with: path)
            }
        }else{
            loadingIV.stopAnimating()
        }
    }

    func makeUI() {
        addSubview(itemView)
        let width = SCREEN_WIDTH - wScale(16)*2
        itemView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
            make.width.equalTo(width)
        }
    
        itemView.addContentView(loadingIV)
        loadingIV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18))
            make.width.height.equalTo(26)
        }
    }
    
    lazy var itemView: ChatMessageItem = {
        ChatMessageItem().then {
            $0.bubbleColor = .white
            $0.isHidden = true
        }
    }()
    
    lazy var loadingIV: UIImageView = {
        UIImageView()
    }()
}


