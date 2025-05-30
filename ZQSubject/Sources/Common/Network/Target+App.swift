
import Foundation
import Moya

protocol AppTargetProtocol: TargetType {}

extension AppTargetProtocol {
    var asMuti: MultiTarget {
        .init(self)
    }
}

/// 默认设置
extension AppTargetProtocol {
    var baseURL: URL {
        env.baseURL()
    }
    
    var headers: [String : String]? {
        return [:]
    }
    // AccessTokenAuthorizable
//    var authorizationType: AuthorizationType? {
//        guard let _ = AppManager.shared.token else { return nil }
//        return .bearer
//    }
}

enum NoAuthTarget {
    /// 发送验证码
    case sendSms(mobile:String)
    /// 登录
    case login(mobile: String, code: String)
    /// 实名认证
    case realAuth(name: String, card: String)
    /// 获得最新版本
    case version
    /// 查询手机号状态 0-禁用 1-正常 2-未激活 3-锁定 4-已注销 5-注销中 9无此用户
    case checkPhone(mobile: String)
}

extension NoAuthTarget: AppTargetProtocol {
    var path: String {
        switch self {
        case .sendSms(_):
            "/user/sendSms"
        case .login(_, _):
            "/user/loginByVerificationCode"
        case .realAuth(_,_):
            "/user/sendId2MetaVerify"

        case  .version:
            "/app/getLastVersion"
        case .checkPhone(_):
            "/user/selectUserStatus"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendSms(_), .version, .checkPhone:
            .get
        default:
            .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .sendSms(let mobile):
            return .requestParameters(parameters: ["mobile":mobile], encoding: URLEncoding.default)
        case .login(let mobile, let code):
            let idfv = UIDevice.current.identifierForVendor?.uuidString ?? "--"
            return .requestParameters(parameters: ["mobile":mobile,
                                                   "verificationCode":code,
                                                   "channelCode":"mrqd",
                                                   "lastDeviceSign":idfv],
                                      encoding: JSONEncoding.default)
        case .realAuth(let name, let card):
            return .requestParameters(parameters: ["userName":name,"idCard":card], encoding: JSONEncoding.default)
        case .version:
            return .requestParameters(parameters: ["type":1], encoding: URLEncoding.default)
        case .checkPhone(let mobile):
            return .requestParameters(parameters: ["mobile":mobile], encoding: URLEncoding.default)
//        default:
//            return .requestPlain
        }
    }
}

enum AuthTarget {
    /// 查询用户信息
    case userinfo
    /// 保存用户问答结果
    case saveQA([JSON])
    /// 退出登录
    case logout
    /// 申请注销
    case logoff
    /// 查询券商列表
    case funds
    /// 查询券商搭载规则
    case fundRule(Int)
    /// 绑定券商账户
    case bindFund(Encodable)
    /// 上传JPEG图片
    case upload(Data)
    /// 修改用户头像
    case updateAvatar(String)
    /// 绑定交易账户
    case bindTrading(String)
    /// 查询量化策略产品列表
    case strategyList
    /// 用户搭载策略产品
    case buildStrategy(Encodable)
    /// 查询订单列表
    case orderList(Int)
    /// 资讯列表
    case articleList(current:Int, size:Int, type:Int)
    /// 意见反馈
    case feedback(Encodable)
    /// 查询用户消息已读未读数
    case unreadMsg
    /// 让用户消息的已读
    case changeMsgRead
    /// 查询用户消息列表
    case messageList(current:Int, size:Int)
    /// 上报用户设备的推送id
    case reportPush(String)
    /// 查询当前登录用户所在渠道对应的活动
    case activity
    /// 查询首页金刚区配置
    case kingKong
    
    /// 查询资源位
    case appResources
    /// 用户故事
    case stroy
    /// 搜索股票
    case stockSearch(keyword: String)
    /// 热门股票
    case stockHot
    /// 获取股票详情
    case stockDetail(String)
    /// 0-未使用 1-已使用 2-已过期
    case coupons(current:Int, size:Int, stauts:Int)

}

extension AuthTarget: AppTargetProtocol {
    var path: String {
        switch self {
        case .userinfo:
            "/user/selectUserInfo"
        case .saveQA(_):
            "/user/updateUserQa"
        case .logout:
            "/user/loginOut"
        case .logoff:
            "user/saveLoginCancelInfo"
        case .funds:
            "/fund/selectAllSecurities"
        case .fundRule(_):
            "/fund/selectCarryRule"
        case .bindFund(_):
            "/fund/bindFundAccount"
        case .upload(_):
            "/api/upload/avatar"
        case .updateAvatar(_):
            "/user/updateUserAvatar"
        case .bindTrading:
            "/fund/bindTradingAccount"
        case .strategyList:
            "/fund/selectStrategyProductPage"
        case .buildStrategy(_):
            "/fund/saveQuantitativeStrategyCarryInfo"
        case .orderList(_):
            "/fund/getOrderListPage"
        case .articleList(_, _, _):
            "/app/informationList"
        case .feedback(_):
            "/app/feedback"
        case .unreadMsg:
            "/user/getUserMessageIsReadCount"
        case .changeMsgRead:
            "/user/userMessageToIsRead"
        case .messageList(_, _):
            "/user/selectUserMessageListPage"
        case .reportPush(_):
            "/user/reportPushId"
        case .activity:
            "/activity/getActivityListByUser"
        case .kingKong:
            "/app/listHomeKingKongDistrict"
        case .appResources:
            "/app/selectResourcePosition"
        case .stroy:
            "/app/getAllUserStoryInfos"
        case .stockSearch(_):
            "stock/search"
        case .stockHot:
            "stock/hot"
        case .stockDetail(let code):
            "stock/detail/\(code)"
        case .coupons(_, _, _):
            "coupons/user"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userinfo, .logout, .funds, .fundRule(_),
                .bindTrading(_), .logoff, .unreadMsg,
                .changeMsgRead, .reportPush(_),.activity,
                .kingKong, .appResources, .stroy, .stockSearch(_), .stockHot, .stockDetail(_):
            .get
        default:
            .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .bindFund(let model), .buildStrategy(let model), .feedback(let model):
            return .requestJSONEncodable(model)
        case .fundRule(let id):
            return .requestParameters(parameters: ["id":id], encoding: URLEncoding.default)
        case .saveQA(let json):
            var temp: JSON =  [:]
            temp["userQaResultList"] = JSON(json)
            return .requestJSONEncodable(temp)
        case .bindTrading(let account):
            return .requestParameters(parameters: ["tradingAccount":account],
                                      encoding: URLEncoding.default)
        case .reportPush(let pushId):
            return .requestParameters(parameters: ["pushId":pushId],
                                      encoding: URLEncoding.default)
            
        case .stockSearch(let keyword):
            /// limit 最大返回条数，默认20条,示例值(20)
            return .requestParameters(parameters: ["keyword":keyword,
                                                   "limit":20],
                                      encoding: URLEncoding.default)
        case .upload(let data):
            return .uploadMultipart([
                MultipartFormData(provider: .data(data),
                                  name: "file", fileName: "image.jpg",
                                  mimeType: "image/jpeg")
            ])
        case .updateAvatar(let url):
            return .requestParameters(parameters: ["avatarUrl":url],
                                      encoding: JSONEncoding.default)
        case .orderList(let userId):
            return .requestParameters(parameters: ["userId":userId,
                                                   "size":-1],
                                      encoding: JSONEncoding.default)
        case .strategyList:
            return .requestParameters(parameters: ["current":0,
                                                   "size":10],
                                      encoding: JSONEncoding.default)
        case .articleList(let current, let size,let type):
            return .requestParameters(parameters: ["current":current,
                                                   "size":size,
                                                   "type":type],
                                      encoding: JSONEncoding.default)
            
        case .messageList(let current, let size):
            return .requestParameters(parameters: ["current":current,
                                                   "size":size],
                                      encoding: JSONEncoding.default)
            
        case .coupons(let current, let size,let status):
            return .requestParameters(parameters: ["pages":current,
                                                   "size":size,
                                                   "status":status],
                                      encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        guard let token = AppManager.shared.token else { return [:] }
        switch self {
        case .upload(_):
            return ["satoken":token,"Content-Type":"multipart/form-data"]
        default:
            return ["satoken":token]
        }
    }
    
}

enum GetTarget {
    case aichat(String)
    case chatHistory
}

extension GetTarget: AppTargetProtocol {
    var path: String {
        switch self {
        case .aichat(_):
            "/stock/smart-selection"
        case .chatHistory:
            "stock/chat-history"
        }
    }
    
    var task: Moya.Task {
        var params: [String: Any] = [:]
        switch self {
        case .aichat(let message):
            params["message"] = message
        default:
            break
        }
        return .requestParameters(parameters: params,
                                  encoding: URLEncoding.default)
    }
    
    var method: Moya.Method {
        return .get
    }
    var headers: [String : String]? {
        guard let token = AppManager.shared.token else { return [:] }
        return ["satoken":token]
    }
}
