
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
        
    }
}
