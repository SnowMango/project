
import Reachability

typealias AppReachability = Reachability

extension Reachability {
    func run() {
        if self.whenReachable == nil {
            self.whenReachable = { reachability in
                Logger.info("⭕️当前网络:\(reachability.connection)")
            }
        }
        if self.whenUnreachable == nil {
            self.whenUnreachable = { _ in
                Logger.info("⭕️无网络状态")
            }
        }
        do {
            try self.startNotifier()
        } catch {
            Logger.warn("⭕️Unable to start notifier")
        }
    }
    
}
