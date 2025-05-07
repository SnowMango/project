
import Reachability

let ReachabilityNoticeName = Notification.Name("NetReachability")
typealias AppReachability = Reachability

extension Reachability {
    func run() {
        if self.whenReachable == nil {
            self.whenReachable = { reachability in
                Logger.info("⭕️当前网络:\(reachability.connection)")
                if kAppManager.currentNetState == false {
                    kAppManager.initAppAPIBlock?()
                    NotificationCenter.default.post(name: ReachabilityNoticeName, object: nil, userInfo: ["state":true])
                }
                kAppManager.currentNetState = true
//                kAppManager.startTask()
            }
        }
        if self.whenUnreachable == nil {
            self.whenUnreachable = { _ in
                Logger.info("⭕️无网络状态")
                kAppManager.currentNetState = false
                NotificationCenter.default.post(name: ReachabilityNoticeName, object: nil, userInfo: ["state":false])
            }
        }
        do {
            try self.startNotifier()
        } catch {
            Logger.warn("⭕️Unable to start notifier")
        }
    }
    
}
