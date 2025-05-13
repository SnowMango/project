
import UIKit
import Then

class CategoriesView: UIView {
    var categories: [(title:String, icon:String, path: String)] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        categories = [("新手指南","beginner.guide",  AppLink.beginner.path),
                      ("开户","kaihu", ""),
//                      ("搭载策略","build.strategy", "/build/strategy"),
                      ("关于我们","home.about.us", AppLink.aboutUs.path),
                      ("风险测评","risk.assessment", AppLink.risk.path),
                      ]
        
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
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: wScale(14), bottom: 0, right: wScale(14))
            $0.register(CategroyCell.self, forCellWithReuseIdentifier: "CategroyCell")
        }
    }()
    
    @objc func noticeRoute() {
        self.window?.hideHud()
        NotificationCenter.default.removeObserver(self)
       
        guard let profile = AppManager.shared.profile else { return }
        if !profile.bindFundsAccount() {
            Router.shared.route(AssetFlowView.FlowStep.account.path)
            return
        }
        if !profile.bindQMTAccount() {
            Router.shared.route(AssetFlowView.FlowStep.system.path)
            return
        }
        if profile.strategySuccess() {
            JumpManager.jumpToWeb(AppLink.assetDetail.path)
            return
        }
        Router.shared.route(AssetFlowView.FlowStep.strategy.path)
    }
}
extension CategoriesView:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.categories[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CategroyCell", for: indexPath) as! CategroyCell
        cell.show(item.icon, with: item.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  (CGRectGetWidth(collectionView.frame) - wScale(14)*2 - 54*4 - 2)/3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.categories[indexPath.row]
        guard let profile = AppManager.shared.profile else { return }
        
        if item.title == "开户" {
            if profile.needRisk() {
                JumpManager.jumpToWeb(AppLink.risk.path)
                return
            }
            if profile.needRealName() {
                Router.shared.route("/commit/auth")
                return
            }
            guard let profile = AppManager.shared.profile else { return }
            if let url = profile.salesStaffInfo?.salespersonQrCode {
                let alert = WindowAlert(title: "截图微信扫码开户", content: "添加客服，进行一对一开户指导", url: url, actionTitle: "在线客服", alertType: .join)
                alert.doneCallBack = {
                    JumpManager.jumpToWeb(AppLink.support.path)
                }
                alert.show()
                
            }
        }else if item.title == "搭载策略" {
            if profile.needRisk() {
                JumpManager.jumpToWeb(AppLink.risk.path)
                return
            }
            if profile.needRealName() {
                Router.shared.route("/commit/auth")
                return
            }
           
            self.window?.showLoading()
            AppManager.shared.refreshUserInfo()
            NotificationCenter.default.addObserver(self, selector: #selector(noticeRoute), name: UserProfileDidUpdateName, object: nil)
            return
        }
        if item.path.hasPrefix("http") {
            JumpManager.jumpToWeb(item.path)
        }else if let link = URL(string: item.path){
            Router.route(url: link)
        }
    }
}
