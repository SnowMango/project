
import UIKit
import Then

class OrderListVC: BaseViewController {

    var orders: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "我的订单"
        setupUI()
        setupLayout()
        orders = ["","","",""]
    }
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.sectionInset = .init(top: wScale(14), left: wScale(14), bottom: wScale(10), right: wScale(14))
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = .init(top: wScale(14), left: wScale(14), bottom: wScale(10), right: wScale(14))

            $0.register(OrderListCell.self, forCellWithReuseIdentifier: "OrderListCell")
        }
    }()
    
}
extension OrderListVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = orders[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"OrderListCell",
                                                       for: indexPath)
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(14)*2,
                     height: wScale(221))
    }

}
