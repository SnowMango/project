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
                
                
                guard let step = item.toastStep, let url = item.imageUrl, step != .done else { callFunc();return }
                guard AppManager.shared.needHomeAd(step.rawValue) else { callFunc();return }
                
                AppManager.shared.doneHomeAd(step.rawValue)
                FreeActivityAlert(url: url, actionTitle: item.toastTitle, moreTitle: item.toastMoreTitle) {
                    if let path = item.toastMainPath {
                        Router.shared.route(path)
                    }
                    callFunc()
                } moreBlock: {
                    if let path = item.toastMorePath {
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

