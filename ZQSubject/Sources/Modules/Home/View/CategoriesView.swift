
import UIKit
import Then

class CategoriesView: UIView {
    enum Category {
        case beginner
        case daily
        case account
        case assessment
        case about
        var title: String {
            switch self {
            case .beginner:
                "新手指南"
            case .daily:
                "每日打卡"
            case .account:
                "开户"
            case .assessment:
                "风险测评"
            case .about:
                "关于我们"
            }
        }
        var icon: String {
            switch self {
            case .beginner:
                "beginner.guide"
            case .daily:
                "beginner.guide"
            case .account:
                "kaihu"
            case .assessment:
                "risk.assessment"
            case .about:
                "home.about.us"
            }
        }
        
        var path: String {
            switch self {
            case .beginner:
                AppLink.beginner.path
            case .daily:
                AppLink.beginner.path
            case .account:
                ""
            case .assessment:
                AppLink.risk.path
            case .about:
                AppLink.aboutUs.path
            }
        }
        
    }
    var categories: [AppIconItem] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
//        categories = [.daily,.account, .assessment, .about]
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(0)
        }
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
