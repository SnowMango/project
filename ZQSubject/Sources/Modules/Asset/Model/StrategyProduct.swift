
import Foundation

struct StrategyProduct: Decodable {
    let id: Int
    let backtestingAnnualizedReturnRate: Float /// 回测年化收益率
    let backtestingDailyWinRate: Float /// 回测日胜率
    let createTime: String? /// 创建时间
    let productDescription: String? /// 量化产品描述
    let productName: String? /// 量化产品名称
    let productTag: String? /// 量化产品标签
}

struct FundsOrder: Decodable {
    let id: Int
    /// 搭载金额
    let carryFund: Float
    /// 搭载时长 /单位 月
    let carryTime: Int
    /// createTime
    let createTime: String?
    /// 我方订单编号
    let orderNo: String?
    /// 付款人名称
    let payerName: String?
    /// 支付账号
    let paymentAccount: String?
    /// 支付订单编号
    let paymentOrderNumber: String?
    /// 支付截图url
    let paymentScreenshotUrl: String?
    /// 券商id
    let securityId: Int?
    /// 券商名称冗余
    let securityName: String?
    /// 服务器费用
    let serviceFund: Float
    /// 服务器时长 /单位 月
    let serviceTime: Int
    /// 技术服务费
    let technicalServiceFee: Float
    /// 合计总额
    let totalFund: Float
    /// 用户id
    let userId: Int?
    
    /// 审核描述
    let verificationMessage: String?
    /// 审核结果 0未审核 1审核通过 2审核不通过
    let verificationResult: Int?
    /// 审核时间
    let verificationTime: String?
    /// 审核人id
    let verificationUserId: Int?
}
