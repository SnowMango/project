
import UIKit
import Then
import Kingfisher

///新手指南
class BeginnerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedItem:Int = 0
    private var items: [AppResource.ResourceData] = []
    func load(_ data: [AppResource.ResourceData]) {
        selectedItem = 0
        self.items = data
        self.isHidden = self.items.count == 0
        self.reloadData()
    }
    
    func reloadData() {
        if self.items.count > 0 {
            let item = items[self.selectedItem]
            imgGuide.kf.setImage(with: item.resourceUrl?.validURL())
        }
        titleCollection.reloadData()
    }
    
    private func setupUI() {
        // 添加卡片视图
        addSubview(titleLb)
        addSubview(cardView)
        cardView.addSubview(titleCollection)
        cardView.addSubview(imgGuide)
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(10))
            make.top.equalTo(12)
            make.right.greaterThanOrEqualTo(0)
        }
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(12)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        titleCollection.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wScale(17))
            make.left.right.equalToSuperview()
            make.height.equalTo(wScale(33))
        }
        
        imgGuide.snp.makeConstraints { make in
            make.top.equalTo(titleCollection.snp.bottom).offset(wScale(13))
            make.height.equalTo(wScale(158))
            make.left.right.equalToSuperview().inset(wScale(12))
            make.bottom.equalToSuperview().inset(wScale(24))
        }
        
        titleLb.text = "新手指南"
    }
    
    //MARK: lazy
    lazy var titleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(17, weight: .heavy)
        }
    }()
    
    /// 整个背景卡片
    private let cardView: UIView = {
        return  UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    private lazy var titleCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: wScale(12), bottom: 0, right: wScale(12))
    
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.registerCell(cls: BeginnerTitleItem.self)
        }
    }()
    
    private lazy var imgGuide: UIImageView = {
        return UIImageView().then {
            $0.addTapGesture(self, sel: #selector(tapImg))
            $0.layer.cornerRadius = wScale(10)
            $0.layer.masksToBounds = true
        }
    }()
}

extension BeginnerView {
    @objc func tapImg() -> Void {
        let item = self.items[selectedItem]
        JumpManager.jumpToWeb(item.linkAddress?.validURL(), superVC: Tools.getTopVC(), interactivePopDisabled: false)
    }
}

extension BeginnerView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReuseCell(BeginnerTitleItem.self, indexPath: indexPath)
        let item = self.items[indexPath.row]
        cell.updateUI(title: item.resourceName,
                      titleColor: indexPath.item == selectedItem ? .white : .kText4,
                      bgColor: indexPath.item == selectedItem ? .kTheme : .kBackGround)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedItem !=  indexPath.item else {
            return
        }
        selectedItem = indexPath.item
        reloadData()
    }
}

extension BeginnerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.items[indexPath.row]
        let title = item.resourceName ?? ""
        let size = title.labelSize(font: .kScale(14, weight: .bold), fixedWidth: 0, fixedHeight: 1024)
        return CGSize(width: wScale(15) + size.width + wScale(15), height: wScale(33))
    
//        return .init(width: wScale(88), height: wScale(33))
    }
}

fileprivate class BeginnerTitleItem: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func updateUI(title: String?, titleColor: UIColor, bgColor: UIColor) {
        contentView.backgroundColor = bgColor
        titleLabel.text = title
        titleLabel.textColor = titleColor
        
        titleLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(titleLabel)
        
        layer.cornerRadius = wScale(16.5)
        layer.masksToBounds = true
        titleLabel.font = .kScale(14, weight: .bold)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualTo(5)
        }
    }
}

