

struct SearchStockModel: Codable, Equatable {
    /// 股票代码
    var code: String
    /// 交易所
    var exchange: String
    /// 股票名称
    var name: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.code == rhs.code && lhs.exchange == rhs.exchange && lhs.name == rhs.name
    }
}

struct HotStockModel: Decodable {
    /// 股票代码
    var code: String
    /// 交易所
    var jys: String
    /// 股票名称
    var name: String
    
    var changePercent: String

}

/// 股票数据模型 (遵循 Codable 协议实现 JSON 解析)
struct Stock: Decodable {
    // MARK: - 必填字段
    /// 股票代码 (示例: "600519")
    let code: String
    /// 交易所 (示例: "SSE")
    let exchange: String
    /// 股票名称 (示例: "贵州茅台")
    let name: String
    /// 净利润(万元) (示例: "5246000")
    let netProfit: String
    /// 营收(万元) (示例: "12361000")
    let revenue: String
    
    let baseInfo: StockBase
    // MARK: - 可选字段
    /// 基金持仓 (示例: "0.85")
    let fundHolding: String?
    /// 收益质量 (示例: "优秀")
    let incomeQuality: String?
    /// 资金流动 (示例: "净流入")
    let liquidity: String?
    /// 市净率 (示例: "15.23")
    let pbRatio: String?
    /// 市盈率 (示例: "45.67")
    let peRatio: String?
    /// 销售收现 (示例: "1.2")
    let salesCash: String?
}

struct StockBase: Decodable {
    // MARK: - 核心标识
    /// 股票代码 (核心标识，示例: "600519")
    let dm: String?
    /// 市场代码 (示例: "cn")
    let ei: String
    /// 交易所代码 (示例: "sh"=上证 "sz"=深证)
    let jys: String?
    
    // MARK: - 名称信息
    /// 股票简称 (示例: "贵州茅台")
    let mc: String?
    /// 股票全称 (示例: "贵州茅台酒股份有限公司")
    let name: String
    
    // MARK: - 交易状态
    /// 停牌状态 (<=0:正常交易，-1=复牌，>=1=停牌天数)
    let `is`: Int  // 使用反引号转义关键字
    
    // MARK: - 价格数据
    /// 当日跌停价 (单位: 元，示例: 185.5)
    let dp: Float?
    /// 当日涨停价 (单位: 元，示例: 225.5)
    let up: Float?
    /// 前收盘价 (单位: 元，示例: 205.0)
    let pc: Float?
    /// 最小价格变动单位 (示例: 0.01)
    let pk: Float?
    
    // MARK: - 股本数据
    /// 流通股本 (单位: 万股，示例: 123456.78)
    let fv: Double?
    /// 总股本 (单位: 万股，示例: 456789.01)
    let tv: Double?
    
    // MARK: - 其他信息
    /// 上市日期 (格式: yyyy-MM-dd，示例: "2001-08-27")
    let od: String?
    /// 冗余股票代码 (部分接口可能返回重复字段)
    let ii: String?
    
    // MARK: - 键值映射
    enum CodingKeys: String, CodingKey {
        case dm, ei, jys, mc, name
        case `is` = "is"
        case dp, up, pc, pk
        case fv, tv
        case od, ii
    }
}

extension StockBase {
    /// 格式化上市日期 (Date类型转换)
    var listingDate: Date? {
        guard let od = od else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: od)
    }
    
    /// 是否处于正常交易状态
    var isTrading: Bool {
        return `is` <= 0
    }
    
    /// 价格涨跌停区间 (元)
    var priceLimitRange: ClosedRange<Float>? {
        guard let low = dp, let high = up else { return nil }
        return low...high
    }
}
