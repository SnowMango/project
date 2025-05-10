//
//  RootViewController.swift
//  ZQSubject
//
//  Created by 郑丰 on 2025/4/11.
//

import UIKit

class RootViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !checkTerms() {
            Router.shared.route(.terms)
            return
        }
        if firstUseApp() {
            Router.shared.route(.firstGuide)
            return
        }
//        Router.shared.route(.home)
        if canAutoLogin() {
            requesUserInfo()
            return
        }
        Router.shared.route(.login)
        
    }
    
    
    func requesUserInfo() {
        guard let token = kUserDefault.string(forKey: UserDefaultKey.userToken.rawValue) else { return }
        AppManager.shared.token = token
        NetworkManager.shared.request(AuthTarget.userinfo) { (result: NetworkResult<UserProfile>) in
            switch result {
            case .success(let response):
                AppManager.shared.profile = response
                if response.needDoQA() {
                    Router.shared.route("/qa")
                }else {
                    Router.shared.route(.home)
                }
                AppManager.shared.reportPush()
            case .failure(_):
                Router.shared.route(.login)
            }
        }
    }
    


    func checkTerms() -> Bool {
        guard let _ = kUserDefault.value(forKey: UserDefaultKey.isAgreeProtocol.rawValue) else { return false }
        return true
    }
    func firstUseApp() -> Bool {
        guard let _ = kUserDefault.value(forKey: UserDefaultKey.firstInstall.rawValue) else {
            return true
        }
        return false
    }
    
    func canAutoLogin() -> Bool {
        guard let _ = kUserDefault.value(forKey: UserDefaultKey.userToken.rawValue) else { return false }
        return true
    }
}
