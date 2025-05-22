
import UIKit
import Then

class HotStockView: RadiusView {
    
    var items: [HotStockModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        self.collectionView.reloadData()
        setNeedsUpdateConstraints()
    }
    
    func makeUI() {
        addSubview(logo)
        logo.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(wScale(18))
        }
        addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(5)
            make.centerY.equalTo(logo)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(wScale(15))
            make.left.right.equalTo(0)
            make.height.equalTo(0)
            make.bottom.lessThanOrEqualTo(wScale(-18))
        }
    }
    
    override func updateConstraints() {
        var rows = self.items.count/2
        if self.items.count & 0x01 == 1 {
            rows += 1
        }
        let height: CGFloat = max((wScale(16) + 16)*CGFloat(rows) - 16, 0)
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        super.updateConstraints()
    }

    lazy var logo: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "hot.atmosphere")
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.text = "热门股票"
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: wScale(14), bottom: 0, right: wScale(14))
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 22
        
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.register(HotStockItem.self, forCellWithReuseIdentifier: "HotStockItem")
        }
    }()
}

extension HotStockView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotStockItem", for: indexPath) as! HotStockItem
        let item = self.items[indexPath.row]
        cell.reload(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = .zero
        size.width = (collectionView.frame.width - wScale(14)*2 - 22 - 1)/2.0
        size.height = wScale(16)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        Router.shared.route("/stock/detail",parameters: ["code": item.code,
                                                         "name": item.name])
    }
}
