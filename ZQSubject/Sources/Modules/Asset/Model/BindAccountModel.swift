
import Foundation

class BindAccountModel: Codable{
    /// 搭载金额
    var carryFund: Float = 100000
    /// 搭载时长 /单位  月
    var carryTime: Int = 12
    /// 资金账户/券商账户
    var fundAccount: String?
    
    ///  付款人名称
    var payerName: String?
    /// 支付账号
    var paymentAccount: String?
    /// 支付订单编号
    var paymentOrderNumber: String?
    /// 支付截图url
    var paymentScreenshotUrl: String?
   
    /// 券商id
    var securityId: Int?
    /// 券商名
    var securityName: String?
    /// 服务器费用
    var serviceFund: Float = 0
    /// 服务器时长 /单位 月
    var serviceTime: Int = 12
    
    ///  技术服务费
    var technicalServiceFee: Float = 0
    /// 合计费用
    var totalFund: Float = 0
    
}

extension BindAccountModel {
    /// 技术服务费
    func service(_ rule: FundsRule) -> Float {
        return Float(rule.serviceCharge) * carryFund * Float(carryTime) / 12.0
    }
    /// 服务器费用
    func server(_ rule: FundsRule) -> Float {
        return Float(rule.serverFees) * Float(serviceTime)/12.0
    }
    
    /// 合计费用
    func total(_ rule: FundsRule) -> Float {
        return server(rule) + service(rule)
    }
}
