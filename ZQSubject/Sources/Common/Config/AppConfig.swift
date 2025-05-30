// 当打包环境是开发环境时，可提供给用户选择的环境
import Foundation

enum Environment: Int {
    case dev     = 1
    case test
    case pro
    
    func name() -> String {
        switch self {
        case .dev:
            return "开发环境"
        case .test:
            return "测试环境"
        case .pro:
            return "生产环境"
        }
    }
    
    func baseURL() -> URL {
        switch self {
        case .dev:
//            return URL(string: "http://192.168.2.200:9091/userService")!
            return URL(string: "https://zqapi-test.zhunqikj.cn/userService")!
        case .test:
            return URL(string: "https://zqapi-test.zhunqikj.cn/userService")!
        case .pro:
            return URL(string: "https://zqapi.zhunqikj.cn/userService")!
        }
    }
    
    var tokenWebHost: String {
        switch self {
        case .dev:
            "https://zqapi-test.zhunqikj.cn/#"
        case .test:
            "https://zqapi-test.zhunqikj.cn/#"
        case .pro:
            "https://zqapi.zhunqikj.cn/#"
        }
    }
    
    var supportHost: String {
        switch self {
        case .dev:
            "https://zqapi-test.zhunqikj.cn"
        case .test:
            "https://zqapi-test.zhunqikj.cn"
        case .pro:
            "https://zqapi.zhunqikj.cn"
        }
    }
}

enum AppLink {
    /// 客服中心
    case support
    /// 用户协议
    case serviceTerms
    /// 隐私协议
    case privacyTerms
    
    /// 我的订单
    case order
    /// 服务器
    case server
    /// 新手指南
    case beginner
    /// 资讯详情
    case news(id: Int)
    /// 风险测评
    case risk

    /// 关于我们
    case aboutUs
    /// 策略详情
//    case strategy(id: Int)
    case freeExperience

}


extension AppLink {
    var path: String {
        switch self {
        case .support:
            "\(env.supportHost)/chat.html"
        case .serviceTerms:
            "\(env.tokenWebHost)/user-service"
        case .privacyTerms:
            "\(env.tokenWebHost)/privacy"
        case .order:
            "\(env.tokenWebHost)/my-order"
        case .server:
            "\(env.tokenWebHost)/op-manage"
        case .beginner:
            "\(env.tokenWebHost)/beginner-guide"
        case .news(let id):
            "\(env.tokenWebHost)/news-detail?news_id=\(id)"
        case .risk:
            "\(env.tokenWebHost)/risk-assessment"
        case .aboutUs:
            "\(env.tokenWebHost)/abuout-us"
        case .freeExperience:
            "\(env.tokenWebHost)/free-experience"
        }
    }
    
    func routing() {
        Router.shared.route(self.path)
    }
    
}

/// 环境配置
#if DEBUG
var env: Environment = .dev
#elseif TEST
var env: Environment = .test
#else
var env: Environment = .pro
#endif

///渠道标识
let channel = "AppStore"

let JPushAK: String  = "f3bf8c9cf6039a0fe6c55ca3"

public let kUserDefault = UserDefaults.standard
// 加下划线的key，是会随着用户退出登录而删除的
enum UserDefaultKey: String {
    
    ///首次安装
    case firstInstall = "FirstInstall3"
    ///版本升级_版本号
    case upgradeAppCode = "UpgradeAppCode"
    ///启动广告数据
    case splashAD = "SplashAD"
    ///用户token
    case userToken = "UserToken"
    ///用户ID
    case userID = "UserID"
    /// 用户编号
    case userNO = "UserNO"
    /// 用户名
    case username = "Username"
    /// 手机号
    case phoneNum = "PhoneNum"
    /// 头像
    case avatar = "Avatar"
    
    
    ///H5域名
    case webHost = "WebHost"
    ///需要添加token的域名
    case tokenWebHost = "TokenWebHost"
    ///是否已经点击同意协议
    case isAgreeProtocol = " isAgreeProtocol"
    ///链接关于我们
    case urlAboutUS = "AboutUS"
    ///链接服务协议
    case urlServiceAgreement = "ServiceAgreement"
    ///链接隐私政策
    case urlPrivacyPolicy = "PrivacyPolicy"
    ///客服电话
    case kefuTel = "kefuTel"
    ///链接客服
    case urlKefu = "urlKefu"
    /// 意见反馈
    case feedback = "Feedback"
    
    /// 我的页面数据
    case mineData = "MineData"
    /// 量化策略页面数据
    case strategyData = "StrategyData"
    /// 量化策略页面广告数据
    case strategyAdData = "StrategyAdData"
    
}

