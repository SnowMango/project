import UIKit
import Kingfisher

typealias finishedCall = (() -> ())?

class PopWindowManager {
    func needUpgrade(_ lhs:String, _ rhs:String) -> Bool {
        if lhs == rhs {
            return false
        }
        let lbs: [String] = lhs.components(separatedBy: ".")
        let rbs: [String] = rhs.components(separatedBy: ".")
        
        for (lf, rf) in zip(lbs, rbs) {
            if let lInt = Int(lf), let rInt = Int(rf) {
                if lInt < rInt {
                    return true
                }
            }
        }
        return false
    }
    ///升级信息
    func showUpgradeViewIfNeeded(_ finishCall: finishedCall) {
        func callFunc() {
            finishCall?()
        }
        let appVersion = kAppVersion
        NetworkManager.shared.request(NoAuthTarget.version) { (result: NetworkResult<VersionInfo>) in
            do {
                let version = try result.get()
                if !self.needUpgrade(appVersion, version.versionName){
                    callFunc()
                    return
                }
                if let ignore = kUserDefault.object(forKey: UserDefaultKey.upgradeAppCode.rawValue) as? String, ignore == version.versionName{
                    /// 非强制版本
                    callFunc()
                    return
                }
                let alert = UpgradeAlert(model: version)
                alert.closeCallBack = {
                    kUserDefault.set(version.versionName, forKey: UserDefaultKey.upgradeAppCode.rawValue)
                    callFunc()
                }
                alert.doneCallBack = {
                    callFunc()
                }
                alert.show()
                
            } catch {
                callFunc()
            }
        }

    }
    
    ///展示闪屏广告
    func showLaunchADViewIfNeeded(_ finishCall: finishedCall) {
        finishCall?()
    }
    
    ///请求闪屏广告,用于下次打开app时显示
    private func getSplashAD() {
//        NetworkManager.shared.request(.theADs(advertCodes: [AdvertCode.Q01]), modelType: [BaseADModel].self, success: { (model) in
//            if let adModel = model?.first {
//                kUserDefault.set(adModel.toJSONString(), forKey: UserDefaultKey.splashAD.rawValue)
//            } else {
//                kUserDefault.removeObject(forKey: UserDefaultKey.splashAD.rawValue)
//            }
//        }) { (_,_) in
//        }
        
    }
    // 步骤 1.体验用户未领取权益 2.体验用户已领取权益未风测 3.体验用户已领取权益已风测未实名 4.体验用户已实名未绑定券商账户 5.体验用户已绑定券商账户
    enum FreeStep: Int {
        case right  = 1
        case risk
        case realName
        case account
        case build
        
        var title: String {
            switch self {
            case .right:
                "立即领取"
            case .risk:
                "立即前往"
            case .realName:
                "立即前往"
            case .account:
                "去开户"
            case .build:
                "去搭载"
            }
        }
        var moreTitle: String? {
            switch self {
            case .account:
                "已开户，去绑定 >"
            case .build:
                "查看服务器信息 >"
            default:
                nil
            }
        }
    
        var mainPath: String? {
            switch self {
            case .right:
                AppLink.freeExperience.path
            case .risk:
                AppLink.risk.path
            case .realName:
                "/commit/auth"
            case .account:
                "/open/account"
            case .build:
                "/build/strategy"
            }
        }
        var morePath: String? {
            switch self {
            case .account:
                "/bind/account"
            case .build:
                AppLink.server.path
            default:
                nil
            }
        }
        
    }
    //MARK:--
    ///主页广告弹窗
    func showHomeADViewIfNeeded(_ finishCall: finishedCall) {
        func callFunc() {
            finishCall?()
        }
       
        NetworkManager.shared.request(AuthTarget.activity) { (result: NetworkResult<ActivityResponse>) in
            do {
                let response = try result.get()
                let freeCode:String = "tyhd"
                guard let item = response.activityInfoList.first(where: { $0.activityCode == freeCode }) else { callFunc(); return}
                // 已领取免费体验权益 且活动未失效
                if item.status != 1 { callFunc();return }
                guard let s = item.step, let step = FreeStep(rawValue: s),let url = item.imageUrl else { callFunc();return }
                guard AppManager.shared.needHomeAd(step.rawValue) else { callFunc();return }
                AppManager.shared.doneHomeAd(step.rawValue)
                FreeActivityAlert(url: url, actionTitle: step.title, moreTitle: step.moreTitle) {
                    if let path = step.mainPath {
                        Router.shared.route(path)
                    }
                    callFunc()
                } moreBlock: {
                    if let path = step.morePath {
                        Router.shared.route(path)
                    }
                    callFunc()
                } closeBlock: {
                    callFunc()
                }.show()
            } catch {
                callFunc()
            }
        }
    }
    
   
}

