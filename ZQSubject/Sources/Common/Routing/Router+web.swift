
import UIKit

extension Router {
    /// web/ 是区分来源添加的
    func webRoutes() {
        /// web调用实名
        route.addRoute("/web/real-name") { _ in
            AppManager.shared.refreshUserInfo()
            return Router.shared.route("/commit/auth")
        }
        /// web调用退出登录
        route.addRoute("/web/login") { _ in
            AppManager.shared.showLogin()
            return true
        }
        
        /// 去开户
        route.addRoute("/web/open-account") { _ in
            return Router.shared.route("/open/account")
        }
        
        /// 绑定券商账户
        route.addRoute("/web/bind-fundAccount") { _ in
            return Router.shared.route(AssetFlowView.FlowStep.account.path)
        }
        
        /// 申请交易系统
        route.addRoute("/web/service") { _ in
            guard let profile = AppManager.shared.profile, let qrUrl = profile.salesStaffInfo?.salespersonQrCode else { return false }
            let title = "截图微信扫码"
            let content = "添加客服，咨询交易账户相关"
            let alert = WindowAlert(title: title, content: content, url: qrUrl, actionTitle: "在线客服", alertType: .join)
            alert.doneCallBack = {
                JumpManager.jumpToWeb(AppLink.support.path)
            }
            alert.show()
            return false
        }
        /// 绑定交易账户
        route.addRoute("/web/bind-tradingAccount") { _ in
            AppManager.shared.refreshUserInfo()
            return Router.shared.route(AssetFlowView.FlowStep.system.path)
        }
        /// 搭载
        route.addRoute("/web/account-carry") { _ in
            AppManager.shared.refreshUserInfo()
            return Router.shared.route(AssetFlowView.FlowStep.strategy.path)
        }
        
        route.addRoute("/web/quantitative-strategy") { _ in
            return Router.shared.route("/strategy")
        }
        
        route.addRoute("/web/feedback") { _ in
            return Router.shared.route("/feedback")
        }
        
        route.addRoute("/web/sales-bullet-frame") { _ in
            guard let profile = AppManager.shared.profile, let qrUrl = profile.salesStaffInfo?.salespersonQrCode else { return false }
            let alert = WindowAlert(title: "截图微信扫码进群", content: "添加客服，加入投资者交流群", url: qrUrl, actionTitle: "在线客服", alertType: .join)
            alert.doneCallBack = {
                JumpManager.jumpToWeb(AppLink.support.path)
            }
            alert.show()
            return false
        }
        route.addRoute("/web/ai-chat") { _ in
            return Router.shared.route("/ai/chat")
        }
    }
}
