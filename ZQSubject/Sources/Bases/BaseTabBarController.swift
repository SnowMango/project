import UIKit

///用于区分底部导航广告URL的标记
enum TabBarURLTag: String {
    case home = "home"
    case strategy = "strategy"
    case asset = "find"
    case me   = "me"
    
    func title() -> String {
        switch self {
        case .home:
            "首页"
        case .strategy:
            "量化策略"
        case .asset:
            "资产"
        case .me:
            "我的"
        }
    }
    
    func icon() -> String {
        switch self {
        case .home:
            "home"
        case .strategy:
            "strategy"
        case .asset:
            "asset"
        case .me:
            "me"
        }
    }
    
    func icon_select() -> String {
        switch self {
        case .home:
            "home_select"
        case .strategy:
            "strategy_select"
        case .asset:
            "asset_select"
        case .me:
            "me_select"
        }
    }
    
    func viewController() -> UIViewController {
        switch self {
        case .home:
            HomeVC(hidesBtmBar: false,navTitle: "")
        case .strategy:
            StrategyVC()
        case .asset:
            AssetVC(hidesBtmBar: false, navTitle: "")
        case .me:
            MeVC(hidesBtmBar: false, navTitle: "")
        }
    }
}

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        tabBar.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _back = tabBar.subviews.first  {
            for sub in _back.subviews {
                if sub is UIImageView {
                    sub.isHidden = true
                }
            }
        }
    }
    ///快速创建控制器-imagename
    func customViewController<T: UIViewController>(_ viewController: T,  itemTitle: String, normalImage: String, selectedImage: String) -> UIViewController {
        
        let navController: BaseNaviController = BaseNaviController(rootViewController: viewController)
        
        let barItem = func_customBarItem(itemTitle: itemTitle,
                                    normalImage: UIImage(named: normalImage)?.withRenderingMode(.alwaysOriginal),
                                    selectedImage: UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal))
        navController.tabBarItem = barItem
        
        return navController
    }
    
    ///快速创建控制器-imageurl
    func customViewController<T: UIViewController>(_ viewController: T,  itemTitle: String?, normalImageURL: String?, selectedImageURL: String?) -> UIViewController {
        
        let navController: BaseNaviController = BaseNaviController(rootViewController: viewController)
     
        let barItem = func_customBarItem(itemTitle: itemTitle,
                                    normalImage: nil,
                                    selectedImage: nil)
        navController.tabBarItem = barItem
        
        getImageFromURL(barItem, normalImageURL, isNormal: true)
        getImageFromURL(barItem, selectedImageURL, isNormal: false)
        return navController
    }
    
    ///快速创建tabBarItem
    private func func_customBarItem(itemTitle: String?, normalImage: UIImage?, selectedImage: UIImage?) -> UITabBarItem {
        let barItem = UITabBarItem(title: itemTitle ?? "",
                                   image: normalImage,
                                   selectedImage: selectedImage)
        barItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        // 设置tabBarItem的普通文字颜色
        barItem.setTitleTextAttributes([.foregroundColor: UIColor.kTheme_grey,
                                        .font: UIFont.systemFont(ofSize: 11)], for: .normal)
        
        // 设置tabBarItem的选中文字颜色
        barItem.setTitleTextAttributes([.foregroundColor: UIColor.kTheme,
                                        .font: UIFont.systemFont(ofSize: 11)], for: .selected)
        
        return barItem
    }
    
    /// 通过网络加载图片
    private func getImageFromURL(_ barItem: UITabBarItem, _ fileURL: String?, isNormal: Bool) {
        guard let fileURL = fileURL else { return }
        //首先拿本地的显示
        if let data = kUserDefault.data(forKey: fileURL), let img = UIImage(data: data) {
            if isNormal {
                barItem.image = resizeImageSize(img, size: CGSize(width: 22, height: 22))?.withRenderingMode(.alwaysOriginal)
            } else {
                barItem.selectedImage = resizeImageSize(img, size: CGSize(width: 22, height: 22))?.withRenderingMode(.alwaysOriginal)
            }
            
        }
        
        ///异步再获取网络图片
        DispatchQueue.global().async {
            if let url = URL(string: fileURL), let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if isNormal {
                        barItem.image = self.resizeImageSize(img, size: CGSize(width: 22, height: 22))?.withRenderingMode(.alwaysOriginal)
                    } else {
                        barItem.selectedImage = self.resizeImageSize(img, size: CGSize(width: 22, height: 22))?.withRenderingMode(.alwaysOriginal)
                    }
                }
                
                kUserDefault.set(data, forKey: fileURL)
                kUserDefault.synchronize()
            }
        }
    }
    
    func resizeImageSize(_ img: UIImage, size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
        
    }
}


