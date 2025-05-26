
import UIKit
import Then

class CouponListVC: BaseViewController {
    var currentPage: Int = 1
    var status: Int = 0
    var items: [Coupon] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [weak self] in
            self?.requestNew()
        })
        collectionView.mj_header?.beginRefreshing()
    }
    
    func makeUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: wScale(16), bottom: 0, right: wScale(16))
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(CouponListCell.self, forCellWithReuseIdentifier: "CouponListCell")
        }
    }()
}

extension CouponListVC {
    func requestMore()  {
        requestList(page: currentPage + 1,true)
    }
    
    func requestNew()  {
        requestList(page: 1, false)
    }
   
    ///请求文章列表
    func requestList(page:Int, _ isLoadMore: Bool = false) {
        let size: Int = 10
        NetworkManager.shared.request(AuthTarget.coupons(current: page, size: size, stauts: self.status)) { (result: NetworkPageResult<Coupon>) in
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
            do {
                self.currentPage = page
                let response = try result.get()
                let dataMore = response.records.count >= size
                if isLoadMore {
                    self.items += response.records
                    if response.records.count < size {
                        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else {
                    self.items = response.records
                    if dataMore {
                        self.collectionView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
                            self?.requestMore()
                        })
                    }else {
                        self.collectionView.mj_footer = nil
                    }
                }
                self.collectionView.reloadData()
            } catch NetworkError.server(_ ,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误刷新失败")
            }
        }
    }
}

extension CouponListVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CouponListCell", for: indexPath) as! CouponListCell
        cell.load(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        size.width = collectionView.frame.width - wScale(16)*2
        size.height = wScale(100)
        if indexPath.row == items.count - 1 {
            size.height = wScale(110)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}
