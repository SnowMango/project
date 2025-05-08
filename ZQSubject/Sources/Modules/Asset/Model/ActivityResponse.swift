
struct ActivityResponse: Decodable {
    let activityInfoList: [Activity]
}

struct Activity: Decodable {
    /// 活动唯一标识码
    let activityCode: String
    /// 活动名称
    let activityName: String?
    /// 1:满减，2:折扣，3:秒杀，4:拼团，5:新人礼包
    let activityType: Int
    /// 活动描述
    let desc: String?
    /// 活动结束时间
    let endTime: String?
    /// 是否领取了当前活动的权益 0未领取 1已领取
    let rights: Int
    /// 活动开始时间
    let startTime: String?
    /// 状态 1生效 2失效
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case activityCode
        case activityName
        case activityType
        case desc = "description"
        case endTime
        case rights
        case startTime
        case status
    }
}
