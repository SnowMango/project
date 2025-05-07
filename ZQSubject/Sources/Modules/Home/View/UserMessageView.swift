
import UIKit
import Then
import Kingfisher

struct UserMessageModel: Decodable {
    let avater: String?
    let nickname: String?
    let time: String?
    let content: String?
    let contentURL: String?
    let likes: Int
}

class UserMessageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadMock()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messages: [UserMessageModel] = []
    
    func loadMock() {
        guard let path = Bundle.main.url(forResource: "message.mock", withExtension: "json") else {
            return
        }
        guard let jsonData = try? Data(contentsOf: path) else {
            return
        }
        guard let items = try? JSONDecoder().decode([UserMessageModel].self, from: jsonData) else {
            return
        }
        
        messages = items
    }
    
    private func setupUI() {
        // 添加卡片视图
        addSubview(titleLb)
        addSubview(collectionView)
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(24))
            make.top.equalTo(wScale(12))
            make.right.greaterThanOrEqualTo(0)
        }
    
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.height.equalTo(wScale(290))
            make.bottom.lessThanOrEqualTo(0)
        }
        titleLb.text = "用户故事"
    }
    
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
        }
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = wScale(12)
        layout.sectionInset = UIEdgeInsets(top: 0, left: wScale(14), bottom: 0, right: wScale(14))
        layout.itemSize = .init(width: wScale(286), height: wScale(290))
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .kBackGround
            $0.showsHorizontalScrollIndicator = false
            $0.register(UserMessageHomeCell.self, forCellWithReuseIdentifier: "UserMessageHomeCell")
        }
    }()
}

extension UserMessageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(messages.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = messages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserMessageHomeCell", for: indexPath) as! UserMessageHomeCell
        cell.load(with: item)
        return cell
    }

}
