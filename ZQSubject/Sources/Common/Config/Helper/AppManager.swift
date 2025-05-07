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
    var currentNetState: Bool?
    
    var token: String?
    var registrationID: String?
    
    var profile: UserProfile?
    var severLastVersion: VersionInfo?
    private var enableRefresh: Bool = true
    func showLogin(reason: String? = nil, _ deleteAccount: Bool = false) {
        removeUserInfo(isDeleteAccount: deleteAccount)
        if let reason = reason {
            Router.shared.route(.login, parameters: [ShowLoginReasonKey: reason])
        }else{
            Router.shared.route(.login)
        }
    }
    
    func setLoginRootVC(_ title: String? = nil, isDeleteAccount: Bool = false) {
        
    }
    
    func refreshUserInfo(){
        guard let _ = kUserDefault.value(forKey: UserDefaultKey.userToken.rawValue) as? String else { return }
        if !self.enableRefresh {
            return
        }
        self.enableRefresh = false
        NetworkManager.shared.request(AuthTarget.userinfo) { (result: NetworkResult<UserProfile>) in
            self.enableRefresh = true
            do {
                let reponse = try result.get()
                self.profile = reponse
                NotificationCenter.default.post(name: UserProfileDidUpdateName, object: nil)
            } catch {
                
            }
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
    
    func resource(with key: String) -> AppResource? {
        guard let resources = self.appResources else {
            return nil
        }
        return resources.first(where: {  $0.resourceKey == key })
    }
    ///登录初始化接口
    func loginInit(_ sucess: (() -> Void)? = nil) {

        NetworkManager.shared.request(NoAuthTarget.appResources) { [self] (result:JSONResult) in
            self.initAppAPIBlock = nil
            sucess?()
            do {
                let json = try result.get()
                if let data = try? json.rawData(), let saveFile = initSaveFilePath() {
                    try? data.write(to: saveFile)
                    self.reloadAppResource()
                }
            } catch {
                self.reloadAppResource()
                sucess?()
            }
        }
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
    
    func saveUserInfo(_ data: LoginModel) {
        kUserDefault.set(data.id, forKey: UserDefaultKey.userID.rawValue)
        kUserDefault.set(data.mobile, forKey: UserDefaultKey.phoneNum.rawValue)
        kUserDefault.set(data.profilePicture, forKey: UserDefaultKey.avatar.rawValue)
        kUserDefault.set(data.token, forKey: UserDefaultKey.userToken.rawValue)
        kUserDefault.set(data.userNo, forKey: UserDefaultKey.userNO.rawValue)
        kUserDefault.set(data.username, forKey: UserDefaultKey.username.rawValue)
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
    
    /// 顺序执行弹窗任务
    /// - Parameter index: 指定从第几个任务开始做
    func startTask(targetIndex: Int? = nil) {
        //如果有目标index,那就会覆盖当前的进度
        if let targetIndex = targetIndex { taskIndex = targetIndex }
        if currentNetState != true && taskIndex != 0 { return }
        if !(UIApplication.shared.keyWindow?.rootViewController is BaseTabBarController) {return}
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
    
    ///app的初始化接口配置信息
    var initAppAPIBlock: (()->())?
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

