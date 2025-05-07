

class StrategyModel: Codable{
  
    /// 绑定券商账户的记录行id
    var carryInfoId: Int?
    /// 资金账户/券商账户
    var fundAccount: String?
    /// 资金账户密码
    var fundPassword: String?
    
    /// 是否开通创业板 0不开通 1开通
    var isOpenChinextBoard: Int = 1
    /// 选择搭载的量化策略产品id
    var quantitativeStrategyProductId: Int?
   
    /// 交易账户
    var tradingAccount: String?
    /// 交易账户密码
    var tradingPassword: String?
    /// 用户id
    var userId: Int?
    
}
