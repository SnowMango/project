import UIKit

let kAppManager = AppManager.shared

let UserProfileDidUpdateName: Notification.Name = .init("UserProfileDidUpdateName")

class AppManager {
    static let shared = AppManager()
    let reachability = try! AppReachability()
    
    private init() {
        reachability.run()
    }
    ///当前网络状态
    var currentNetState: Bool {
        reachability.connection != .unavailable
    }
    
    var token: String?
    var registrationID: String?
    
    var profile: UserProfile?
    var severLastVersion: VersionInfo?
    private var enableRefresh: Bool = true
    
    func showLogin(reason: String? = nil, _ deleteAccount: Bool = false) {
        removeUserInfo(isDeleteAccount: deleteAccount)
        taskIndex = 0
        taskExecuting = false
        self.enableRefresh = true
        self.token = nil
        self.profile = nil
        if let reason = reason {
            Router.shared.route(.login, parameters: [ShowLoginReasonKey: reason])
        }else{
            Router.shared.route(.login)
        }
    }
    
    func refreshUserInfo(){
        guard let _ = self.token else {
            NotificationCenter.default.post(name: UserProfileDidUpdateName, object: nil)
            return
        }
        if !self.enableRefresh {
            return
        }
        self.enableRefresh = false
        NetworkManager.shared.request(AuthTarget.userinfo) { (result: NetworkResult<UserProfile>) in
            self.enableRefresh = true
            do {
                let reponse = try result.get()
                self.profile = reponse
            } catch {
            }
            NotificationCenter.default.post(name: UserProfileDidUpdateName, object: nil)
        }
    }

    func initSaveFilePath() -> URL? {
        guard let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cache.appendingPathComponent("AppInit.json")
    }
    
    
    func reloadAppResource() {
        guard let path = initSaveFilePath() else { return }
        guard let jsonData: Data = try? .init(contentsOf: path) else { return }
        if let response = try? JSONDecoder().decode( [AppResource].self, from: jsonData) {
            self.appResources = response
        }
    }
    var appResources:[AppResource]?
    
    var kingKongItems:[AppIconItem]?
    
    func resource(with key: String) -> AppResource? {
        guard let resources = self.appResources else {
            return nil
        }
        return resources.first(where: {  $0.resourceKey == key })
    }
    /// 资源位获取
    func loginInit(_ sucess: (() -> Void)? = nil) {
        NetworkManager.shared.request(AuthTarget.appResources) { [self] (result:JSONResult) in
            do {
                let json = try result.get()
                if let data = try? json.rawData(), let saveFile = initSaveFilePath() {
                    try? data.write(to: saveFile)
                    self.reloadAppResource()
                }
            } catch {
                self.reloadAppResource()
            }
            sucess?()
        }
    }
    
    func kingkong(with position: Int) -> [AppIconItem]? {
        guard let resources = self.kingKongItems else {
            return nil
        }
        return resources.filter{ $0.position == position }.sorted { $0.sort < $1.sort }
    }
    
    func kingkongFilePath() -> URL? {
        guard let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cache.appendingPathComponent("kingkong.json")
    }
    
    func refreshKingkong(_ sucess: (() -> Void)? = nil) {
        NetworkManager.shared.request(AuthTarget.kingKong) { [self] (result:JSONResult) in
            do {
                let json = try result.get()
                if let data = try? json.rawData(), let saveFile = kingkongFilePath() {
                    try? data.write(to: saveFile)
                    self.reloadKingkong()
                }
                sucess?()
            } catch {
                self.reloadKingkong()
                sucess?()
            }
            
        }
    }
    
    func reloadKingkong() {
        guard let path = kingkongFilePath() else { return }
        guard let jsonData: Data = try? .init(contentsOf: path) else { return }
        if let response = try? JSONDecoder().decode( [AppIconItem].self, from: jsonData) {
            self.kingKongItems = response
        }
    }
    
    func needHomeAd(_ step: Int) -> Bool {
        guard let profile = profile else { return false }
        if profile.strategySuccess() {
            return false
        }
        let key = "\(profile.id)-s\(step)-homeAD-LastTime"
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd"
       
        guard let value = kUserDefault.string(forKey: key),let lastTime = fm.date(from: value) else { return true }
        let calendar = NSCalendar.current
        return !calendar.isDateInToday(lastTime)
    }
    
    func doneHomeAd(_ step: Int){
        guard let profile = profile else { return }
        let key = "\(profile.id)-s\(step)-homeAD-LastTime"
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd"
        
        let last = fm.string(from: .now)
        kUserDefault.set(last, forKey: key)
        kUserDefault.synchronize()
    }
    
    func reportPush() {
        guard  let _ = self.token, let pushId = self.registrationID else {
            return
        }
        NetworkManager.shared.request(AuthTarget.reportPush(pushId)) {(result:OptionalJSONResult) in
            do {
                let _ = try result.get()
                Logger.verbose("Report registrationID success")
            } catch let error {
                Logger.error("Report registrationID \(error.localizedDescription)")
            }
        }
    }
    

    func removeUserInfo(isDeleteAccount: Bool = false) {
        if (isDeleteAccount) {
            kUserDefault.removeObject(forKey: UserDefaultKey.phoneNum.rawValue)
        }
        kUserDefault.removeObject(forKey: UserDefaultKey.userToken.rawValue)
    }
    
    ///如果被销毁,网络数据回来后,不再弹窗
    private(set) var popWinManager: PopWindowManager?
    //当前任务
    var taskIndex = 0
    //任务是否在进行中
    var taskExecuting = false
    let queue = DispatchQueue(label: "taskQueue")
    
    func reloadTask() {
        if taskExecuting { return }
        if taskIndex > 3 {
            taskIndex = 2
        }
        self.startTask()
    }
    /// 顺序执行弹窗任务
    /// - Parameter index: 指定从第几个任务开始做
    func startTask(targetIndex: Int? = nil) {
        //如果有目标index,那就会覆盖当前的进度
        if let targetIndex = targetIndex { taskIndex = targetIndex }
        if currentNetState != true && taskIndex != 0 { return }
        if taskExecuting { return }
        taskExecuting = true
        taskIndex += 1
        popWinManager = popWinManager ?? PopWindowManager()
        weak var ws = self
        switch taskIndex {
        case 1:
            //闪屏广告
            popWinManager?.showLaunchADViewIfNeeded {
                ws?.taskExecuting = false
                ws?.startTask()
            }
        case 2:
            //升级弹窗
            popWinManager?.showUpgradeViewIfNeeded {
                ws?.taskExecuting = false
                ws?.startTask()
            }
        case 3:
            //首页广告弹窗
            popWinManager?.showHomeADViewIfNeeded {
                ws?.taskExecuting = false
                ws?.startTask()
            }
        default:
            taskExecuting = false
            popWinManager = nil
            break
        }
    }
}

extension AppManager {
    func defaultRootViewController() -> BaseTabBarController {
        let tabVC = BaseTabBarController()
        tabVC.tabBar.isTranslucent = false
      
        func genrateVC(_ tag: TabBarURLTag) -> UIViewController {
            return  tabVC.customViewController(tag.viewController(), itemTitle: tag.title(), normalImage: tag.icon(), selectedImage: tag.icon_select())
        }
        
        //使用默认的
        let vcs = [
            genrateVC(.home),
            genrateVC(.strategy),
            genrateVC(.asset),
            genrateVC(.me)
        ]
        
        tabVC.setViewControllers(vcs, animated: false)
        return tabVC
        
        
     }
}

