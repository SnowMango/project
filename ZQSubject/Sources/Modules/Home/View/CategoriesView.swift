
import UIKit
import Then

class CategoriesView: UIView {
     
    var categories: [AppIconItem] = [] {
        didSet {
            reoladData()
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
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
            make.height.equalTo(0)
        }
    }
    
    func reoladData() {
        self.collectionView.reloadData()
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        var rows = categories.count/4
        if categories.count%4 != 0 {
            rows += 1
        }
        var hight: CGFloat = CGFloat(rows)*85
        if rows > 0 {
            hight -= 15
        }
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(hight)
        }
        super.updateConstraints()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 54, height: 70)
        layout.minimumLineSpacing = 15
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: wScale(14), bottom: 0, right: wScale(14))
            $0.register(CategroyCell.self, forCellWithReuseIdentifier: "CategroyCell")
        }
    }()

}
extension CategoriesView:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.categories[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CategroyCell", for: indexPath) as! CategroyCell
        cell.show(item.iconUrl, with: item.iconName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  (CGRectGetWidth(collectionView.frame) - wScale(14)*2 - 54*4 - 2)/3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.categories[indexPath.row]    
        if let url = item.iconLinkUrl, let link = URL(string: url){
            Router.route(url: link)
        }
    }
}
