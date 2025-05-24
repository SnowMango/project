
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
