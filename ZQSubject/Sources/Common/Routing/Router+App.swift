
import UIKit

extension Router {

    func appRoutes() {
        route.addRoute("/home") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            if let _ = window.rootViewController as? BaseTabBarController {
                return false
            }
            window.rootViewController = kAppManager.defaultRootViewController()
            return true
        }
        
        route.addRoute("/back/home") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            guard let rootTab = window.rootViewController as? BaseTabBarController else { return false }
            
            if let navi = rootTab.selectedViewController as? UINavigationController {
                navi.popToRootViewController(animated: true)
            }else {
                rootTab.selectedViewController?.navigationController?.popToRootViewController(animated: true)
            }
            return true
        }
        route.addRoute("/terms") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            window.rootViewController = BaseNavigationController(rootViewController:PrivacyVC())
            return true
        }
        
        route.addRoute("/login") { params in
            guard let window = UIApplication.shared.keyWindow else { return false }
            if let root = window.rootViewController as? BaseNavigationController, let _ = root.viewControllers.first as? LoginVC {
                return false
            }
            let vc = LoginVC()
            if let reason = params[ShowLoginReasonKey] as? String {
                vc.showReason = reason
            }
            window.rootViewController = BaseNavigationController(rootViewController: vc)
            return true
        }
        
        route.addRoute("/firstGuide") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            if let _ = window.rootViewController as? AppGuideVC {
                return false
            }
            window.rootViewController = AppGuideVC()
            return true
        }
        
        /// 开户
        route.addRoute("/open/account") { _ in
            guard let profile = AppManager.shared.profile, let qrUrl = profile.salesStaffInfo?.salespersonQrCode else { return false }
            let title = "截图微信扫码开户"
            let content = "添加客服，进行一对一开户指导"
            let alert = WindowAlert(title: title, content: content, url: qrUrl, actionTitle: "在线客服", alertType: .join)
            alert.doneCallBack = {
                AppLink.support.routing()
            }
            alert.show()
            return false
        }
        
        /// 绑定券商账号
        route.addRoute("/bind/account") { _ in
            
            UIApplication.shared.open(BindAccountVC(), animated: true)
            return true
        }
        
        /// 交易系统账号
        route.addRoute("/bind/system/account") { _ in

            UIApplication.shared.open(BindSystemAccountVC(), animated: true)
            return true
        }
        /// 搭载量化策略
        route.addRoute("/build/strategy") { _ in
            UIApplication.shared.open(BuildStrategyVC(), animated: true)
            return true
        }
        
        ///
        route.addRoute("/strategy") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            guard let rootTab = window.rootViewController as? BaseTabBarController else { return false }
            if let navi = rootTab.selectedViewController as? UINavigationController {
                navi.popToRootViewController(animated: true)
            }else {
                rootTab.selectedViewController?.navigationController?.popToRootViewController(animated: true)
            }
            rootTab.selectedIndex = 1
            return true
        }
        
        /// 设置
        route.addRoute("/app/setting") { _ in
            UIApplication.shared.open(SettingVC(), animated: true)
            return true
        }
        
        /// 反馈
        route.addRoute("/feedback") { _ in
            UIApplication.shared.open(FeedbackCV(), animated: true)
            return true
        }
        
        /// 实名认证
        route.addRoute("/commit/auth") {
            if let profile = AppManager.shared.profile,  profile.isRealName == 1 {
                if let name = profile.username, let card = profile.idCard {
                    let vc = RealAuthResultVC()
                    vc.name = name
                    vc.cardNumber = card
                    if let _ = $0["needOpen"]{
                        vc.needOpen = false
                    }
                    UIApplication.shared.open(vc, animated: true)
                    return true
                }
            }
            let vc = RealAuthVC()
            if let _ = $0["needOpen"]{
                vc.needOpen = false
            }
            UIApplication.shared.open(vc, animated: true)
            return true
        }
        route.addRoute("/auth/result") {
            guard let name = $0["name"] as? String else { return false }
            guard let card = $0["idCard"] as? String else { return false }
            
            let vc = RealAuthResultVC()
            vc.name = name
            vc.cardNumber = card
            if let _ = $0["needOpen"]{
                vc.needOpen = false
            }
            UIApplication.shared.open(vc, animated: true)
            return true
        }
        
        /// 服务器管理
        route.addRoute("/servers") { _ in
            UIApplication.shared.open(SeverListVC(), animated: true)
            return true
        }
        
        /// 我的订单
        route.addRoute("/orders") { _ in
            UIApplication.shared.open(OrderListVC(), animated: true)
            return true
        }
        
        /// 问答
        route.addRoute("/qa") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            window.rootViewController = BaseNavigationController(rootViewController:UserQA1VC())
            return true
        }
        
        /// 问答
        route.addRoute("/message") { _ in
            UIApplication.shared.open(MessageListVC(), animated: true)
            return true
        }
        
        route.addRoute("/search/stock") { _ in
            UIApplication.shared.open(StockSearchVC(), animated: true)
            return true
        }
        
        route.addRoute("/stock/detail") {
            guard let code = $0["code"] as? String else { return false }
            let vc = StockDetailVC()
            vc.stockCode = code
            if let name = $0["name"] as? String {
                vc.stockName = name
            }
            UIApplication.shared.open(vc, animated: true)
            return true
        }
        
        route.addRoute("/ai/chat") { _ in
            UIApplication.shared.open(StockSearchVC(), animated: true)
            return true
        }
        
    }
}

