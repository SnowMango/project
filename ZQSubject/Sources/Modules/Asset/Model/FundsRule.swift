
struct FundsRule: Decodable {
    let minCarryFund: Float /// 搭载资金最低限额
    var minCarryTime: Int = 1 /// 搭载时长最低时长(单位年)
    let securitiesFirms: String? /// 券商公司名
    let securitiesId: Int /// 券商公司id
    let serverFees: Float /// 服务器费用/1年
    let serviceCharge: Float /// 服务费占搭载金额的比例
}

