
import UIKit

class SettingVC: BaseViewController {
    
    private lazy var tableview = {
        let tbv = UITableView(frame: .zero, style: .plain)
        tbv.dataSource = self
        tbv.delegate = self
        tbv.registerCell(cls: SettingCell.self)
        tbv.separatorStyle = .none
        tbv.backgroundColor = .white
        tbv.layer.cornerRadius = wScale(8)
        tbv.isScrollEnabled = false
        return tbv
    }()
    
    private var datas = [
        "关于我们",
        "服务协议",
        "隐私政策",
        "注销账号"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        title = "设置"
        fd_prefersNavigationBarHidden = false
        
        let lb1 = UILabel()
        lb1.font = .kFontScale(13)
        lb1.textColor = .kText1
        lb1.text = "账号和隐私"
        view.addSubview(lb1)
        lb1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wScale(17.5))
            make.left.equalToSuperview().offset(wScale(20))
        }
        
        let height = CGFloat(datas.count) * wScale(49)
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(wScale(44.5))
            make.left.right.equalToSuperview().inset(wScale(14))
            make.height.equalTo(height)
        }
        
        let versionLb = UILabel()
        versionLb.font = .kFontScale(13)
        versionLb.textColor = .kText1
        versionLb.numberOfLines = 0
        versionLb.textAlignment = .center
        let production: String = switch env {
        case .dev: "当前版本(V\(kAppVersion))\n\(AppBuildVersion)"
        case .test: "当前版本(V\(kAppVersion))\n\(AppBuildVersion)"
        case .pro: "当前版本(V\(kAppVersion))"
        }
        versionLb.text = production
        view.addSubview(versionLb)
        versionLb.snp.makeConstraints { make in
            make.top.equalTo(tableview.snp.bottom).offset(wScale(11.5))
            make.centerX.equalToSuperview()
        }
        
        let btn = UIButton()
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .kFontScale(17)
        btn.layer.cornerRadius = wScale(24)
        btn.backgroundColor = .kTheme
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(wScale(14))
            make.height.equalTo(wScale(48))
            make.bottom.equalToSuperview().inset(SCREEN_HEIGHT * 127.0 / 812.0)
        }
    }
    
    @objc private func logout() {
        let alert = WindowAlert(title: "温馨提示", content: "您确定要退出登录吗？退出后将无法查看您的资产情况。", actionTitle: "确认退出", closeTitle: "取消", alertType: .double)
        alert.show()
        alert.doneCallBack = {
            NetworkManager.shared.request(AuthTarget.logout) { (result: OptionalJSONResult) in
                
            }
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            kAppManager.showLogin()
        }
    }
    
    @objc private func deleteAccount() {
        let alert = WindowAlert(title: "注销账户", content: "注销账号会清空所有信息和数据，您是否确认注销？", actionTitle: "注销", closeTitle: "取消", alertType: .double)
        alert.show()
        alert.doneCallBack = { [weak self] in
            self?.view.showLoading()
            NetworkManager.shared.request(AuthTarget.logoff) { (result: OptionalJSONResult) in
                self?.view.hideHud()
                do {
                    let _ = try result.get()
                    kAppManager.showLogin(true)
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                } catch NetworkError.server(_,let message) {
                    self?.view.showText(message)
                } catch {
                    self?.view.showText("网络错误，请求失败")
                }
            }
        }
    }
}

extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReuseCell(SettingCell.self, indexPath: indexPath)
        cell.titleLb.text = datas[indexPath.row]
        cell.line.isHidden = indexPath.row == datas.count - 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return wScale(49)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = datas[indexPath.row]
        switch title {
        case "关于我们":
            JumpManager.jumpToWeb(AppLink.aboutUs.path)
        case "服务协议":
            JumpManager.jumpToWeb(AppLink.serviceTerms.path)
        case "隐私政策":
            JumpManager.jumpToWeb(AppLink.privacyTerms.path)
        case "注销账号":
            deleteAccount()
            return
        default:
            break
        }
    
    }
    
}
