
import Foundation

class UserProfile: Decodable {
    var availablePoints: Int? ///可用积分
    var couponCount: Int? ///优惠券数量

    var avatar: String? /// 头像URL
    var createTime: String? /// 创建时间
    var email: String?  /// 邮箱
    var fundAccount: String? /// 资金账户
    var gender: Int? /// 0未知 1男 2女
    var id: Int ///  用户id
    var channelCode: String?
    var idCard: String? //身份证
    var isRealName: Int? /// 是否实名认证  1认证通过 2认证不通过 3未知
    var isUserQa: Int? /// 是否用户问答
    var mobile: String? /// 手机号
    var nickname: String? ///  昵称/显示名称
    var password: String? /// 密码
    var riskAssessmentFailureTime: String? /// 风险评测的失效时间
    var riskAssessmentScore: Int?  /// 风险评测的分数
    var status: Int?  /// 0-禁用 1-正常 2-未激活 3-锁定
    var tradingAccount: String? /// 交易账户
    var updateTime: String? /// 修改时间
    var username: String? /// 用户名
    /// 用户搭载量化策略产品实体
    var quantitativeStrategyCarryInfoList: [UserStrategyInfo]?
    /// 用户绑定服务器
    var userBindServerList: [UserServerInfo]?
    
    var orderVerificationList: [OrderVerification]?
    
    /// 用户的对接销售
    var salesStaffInfo:SalesStaffInfo?
    
    var userServerStatusBoard: StatusBoard?
    
    func needDoQA() -> Bool {
        return self.isUserQa != 2
    }
    
    /// 是否需要用户风险评测
    func needRisk() -> Bool {
        let foramt = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
        if let timeStr = self.riskAssessmentFailureTime, let time = foramt.date(from: timeStr){
            return time.timeIntervalSince1970 < Date().timeIntervalSince1970
        }
        return true
    }
    
    /// 是否需要实名
    func needRealName() -> Bool {
        return self.isRealName != 1
    }
    
    /// 是否绑定券商
    func bindFundsAccount() -> Bool {
        guard let _ = self.fundAccount else { return false }
        return true
    }
    
    /// 是否绑定交易账号
    func bindQMTAccount() -> Bool {
        guard let _ = self.tradingAccount else { return false }
        return true
    }
    
    /// 用户是否搭载成功
    func strategySuccess() -> Bool {
        guard let strategy = self.quantitativeStrategyCarryInfoList?.first else { return false }
        return strategy.verificationResult == 1
    }
}

struct UserStrategyInfo: Decodable {
    /// 绑定券商账户的记录行id
    let carryInfoId: Int?
    /// 创建时间
    let createTime: String?
    /// 资金账户
    let fundAccount: String?
    /// 资金账户密码
    let fundPassword: String?
    /// 是否开通创业板 0不开通 1开通
    let isOpenChinextBoard: Int?
    /// 选择搭载的量化策略产品id
    let quantitativeStrategyProductId: Int?
    /// 交易账户
    let tradingAccount: String?
    /// 交易账户密码
    let tradingPassword: String?
    
    /// 用户id 外键
    let userId: Int?
    /// 审核描述
    let verificationMessage: String?
    /// 审核结果 0未审核 1审核通过 2审核不通过
    let verificationResult: Int?
    /// 审核时间
    let verificationTime: String?
    /// 审核人ID
    let verificationUserId: Int?
}

struct UserServerInfo: Decodable {
    /// 创建时间
    let createTime: String?
    /// mac地址
    let macAddress: String?
    /// 订单编号
    let orderId: Int?
    /// 服务器ip
    let serverIp: String?
    /// 所属用户ID
    let userId: Int?
}


struct SalesStaffInfo: Decodable {
    /// 销售人员名称
    let salespersonName: String?
    /// 销售人员名称
    let salespersonPhone: String?
    /// 销售人员二维码
    let salespersonQrCode: String?
    ///
    let bindUserCount: Int?
    /// 时间
    let createTime: String?
}

struct OrderVerification: Decodable {
    
    let carryInfoId: Int?
    let createTime: String?
    let orderNo: String?
    let userId: Int?
    
    let verificationMessage: String?
    let verificationResult: Int
    let verificationTime: String?
    let verificationUserId: Int?
}


struct StatusBoard: Decodable {
    
    /// 搭载进度
    let loadingProgress: String?
    /// 搭载步骤 开户|开通交易系统|搭载策略
    let loadingStep: String?
   
    /// 注意事项
    let precautions: String?
    /// 步骤对应的图片，多张图片|分割
    let stepPicture:String?
    /// 跳转地址描述
    let jumpLinkDescribe: String?
    /// 跳转实际地址
    let jumpLinkAddress: String?
    /// 按钮文案
    let buttonText: String?
    let buttonLinkAddress: String?
    
    /// 描述图标
    let describeIcon: String?
    /// 描述
    let describeMessage: String?
    
    func steps() -> [String]? {
        guard let loadingStep = loadingStep else { return nil }
        return loadingStep.components(separatedBy: "|")
    }

    func pictures() -> [String]? {
        guard let stepPicture = stepPicture else { return nil }
        return stepPicture.components(separatedBy: "|")
    }
    
    func mapPrecautions() -> String? {
        guard let precautions = precautions else { return nil }
        return precautions.components(separatedBy: "|").joined(separator: "\n")
    }
   
}


