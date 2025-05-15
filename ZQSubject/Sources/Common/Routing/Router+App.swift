
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
            window.rootViewController = BaseNaviController(rootViewController:PrivacyVC())
            return true
        }
        
        route.addRoute("/login") { params in
            guard let window = UIApplication.shared.keyWindow else { return false }
            if let root = window.rootViewController as? BaseNaviController, let _ = root.viewControllers.first as? LoginVC {
                return false
            }
            let vc = LoginVC()
            if let reason = params[ShowLoginReasonKey] as? String {
                vc.showReason = reason
            }
            window.rootViewController = BaseNaviController(rootViewController: vc)
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
                JumpManager.jumpToWeb(AppLink.support.path)
            }
            alert.show()
            return false
        }
        
        /// 绑定券商账号
        route.addRoute("/bind/account") { _ in
            Tools.getTopVC().navigationController?.show(BindAccountVC(), sender: nil)
            return true
        }
        
        /// 交易系统账号
        route.addRoute("/bind/system/account") { _ in
            Tools.getTopVC().navigationController?.show(BindSystemAccountVC(), sender: nil)
            return true
        }
        /// 搭载量化策略
        route.addRoute("/build/strategy") { _ in
            Tools.getTopVC().navigationController?.show(BuildStrategyVC(), sender: nil)
            return true
        }
        
        /// 设置
        route.addRoute("/app/setting") { _ in
            Tools.getTopVC().navigationController?.show(SettingVC(), sender: nil)
            return true
        }
        
        /// 反馈
        route.addRoute("/feedback") { _ in
           
            Tools.getTopVC().navigationController?.show(FeedbackCV(), sender: nil)
    
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
                    Tools.getTopVC().navigationController?.show(vc, sender: nil)
                    return true
                }
            }
            let vc = RealAuthVC()
            if let _ = $0["needOpen"]{
                vc.needOpen = false
            }
            Tools.getTopVC().navigationController?.show(vc, sender: nil)
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
            Tools.getTopVC().navigationController?.show(vc, sender: nil)
            return true
        }
        
        /// 服务器管理
        route.addRoute("/servers") { _ in
            Tools.getTopVC().navigationController?.show(SeverListVC(), sender: nil)
            return true
        }
        
        /// 我的订单
        route.addRoute("/orders") { _ in
            Tools.getTopVC().navigationController?.show(OrderListVC(), sender: nil)
            return true
        }
        
        /// 问答
        route.addRoute("/qa") { _ in
            guard let window = UIApplication.shared.keyWindow else { return false }
            window.rootViewController = BaseNaviController(rootViewController:UserQA1VC())
            return true
        }
        
        /// 问答
        route.addRoute("/message") { _ in
            Tools.getTopVC().navigationController?.show(MessageListVC(), sender: nil)
            return true
        }
        
        
    }
}

