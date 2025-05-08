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
//        getSplashAD()
//        
//        func callFunc() {
//            finishCall?()
//        }
//        
//        guard let adStr = kUserDefault.value(forKey: UserDefaultKey.splashAD.rawValue),
//              let adModel = BaseADModel.deserialize(from: adStr as? String),
//              let imgURL = adModel.highPhoto
//        else {
//            callFunc()
//            return
//        }
//        
//        let splashView = SplashAD(imageUrl: imgURL, adUrl: adModel.linkUrl) { (didTap) in
//            
//            //有广告链接才跳转
//            guard let url = adModel.linkUrl, url.count > 0, didTap else {
//                callFunc()
//                return
//            }
//            
//            JumpManager.jumpToWeb(url, superVC: Tools.getTopVC(), dismissedBlock: callFunc)
//        }
//        splashView.show()
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
    
    
    //MARK:--
    ///主页广告弹窗
    func showHomeADViewIfNeeded(_ finishCall: finishedCall) {
//        finishCall?()
        func callFunc() {
            finishCall?()
        }
        guard AppManager.shared.needHomeAd() else { return }
        
        AppManager.shared.doneHomeAd()
        let alert = WindowAlert(url: "https://zhunqi-liangjie.oss-cn-shenzhen.aliyuncs.com/banner%E5%9B%BE/%E4%BB%80%E4%B9%88%E6%98%AF%E9%87%8F%E5%8C%96.png", actionTitle: "立即参与",alertType: .image)
        alert.closeCallBack = {
            callFunc()
        }
        alert.imageViewCallBack = {
            callFunc()
        }
        alert.doneCallBack = {
            callFunc()
        }
        alert.show()

    }
}
