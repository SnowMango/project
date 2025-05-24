import UIKit

///跳转的方法集合
struct JumpManager {
  
    ///处理链接的token,判断是否需要添加token
    static func tokenSet(url: String) -> String {
        var result: String = url
        if url.contains("token") {
            let hostList = env.tokenWebHost.split(separator: ",")
            //循环host,判断是否需要添加token
            hostList.forEach { (host) in
                if result.contains(host){
                    guard let token = kUserDefault.string(forKey: UserDefaultKey.userToken.rawValue) else { return }
                    ///判断链接是否已拼接有参数
                    if result.contains("?") {
                        result = result + "&token=\(token)"
                    } else {
                        result = result + "?token=\(token)"
                    }
                    
                }
            }
        }
        return result
    }
    
    ///处理链接的host,判断是否需要添加host
    static func webHostSet(_ url: String) -> String {
        var resultUrl: String = url
        if !url.contains("http") && !url.contains("https") {
            //拼接域名
            if let host = kUserDefault.string(forKey: UserDefaultKey.webHost.rawValue) {
                resultUrl = host + url
            }
        }
        return tokenSet(url: resultUrl)
    }
    
    
    ///必须调用这个
    private static func pushWeb(url: String, originUrl: String? = nil, pp_superVC: UIViewController, web: BaseWebController, removeTopWebBeforePush: Bool = false) {
        web.startLoadUrl(url: url, originUrl: originUrl)
        var vcs = pp_superVC.navigationController?.viewControllers ?? []
        if removeTopWebBeforePush, vcs.last is BaseWebController {
            vcs.removeLast()
            vcs.append(web)
            pp_superVC.navigationController?.setViewControllers(vcs, animated: true)
        } else {
            pp_superVC.navigationController?.pushViewController(web, animated: true)
        }
    }
    
    /// 跳转H5页面
    /// - Parameters:
    ///   - url: 链接
    ///   - pp_superVC: pp_superVC
    ///   - removeTopWebBeforePush: 移除顶部（即当前）web，再push新的web
    ///   - interactivePopDisabled: 是否禁止侧滑返回，默认false
    @discardableResult static func jumpToWeb(
        _ url: String?,
        superVC: UIViewController? = Tools.getTopVC(),
        removeTopWebBeforePush: Bool = false,
        interactivePopDisabled: Bool? = nil,
        dismissedBlock: (() -> ())? = nil
    ) -> BaseWebController? {
        guard let url = url, !url.isEmpty, let superVC = superVC else {
            return nil
        }
        
        let adWeb = BaseWebController()
        if let disabled = interactivePopDisabled {
            adWeb.hiddenNavigationBarWhenShow = disabled
        }
        adWeb.dismissedBlock = dismissedBlock
        
        pushWeb(url: url, pp_superVC: superVC, web: adWeb, removeTopWebBeforePush: removeTopWebBeforePush)
        return adWeb
    }
    
  
    
}
