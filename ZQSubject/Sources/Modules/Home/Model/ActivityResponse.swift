
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
//    let desc: String?
    /// 活动结束时间
    let endTime: String?
    /// 是否领取了当前活动的权益 0未领取 1已领取
    let rights: Int
    /// 活动开始时间
    let startTime: String?
    /// 状态 1生效 2失效
    let status: Int?
    /// 步骤 1.体验用户未领取权益 2.体验用户已领取权益未风测 3.体验用户已领取权益已风测未实名 4.体验用户已实名未绑定券商账户 5.体验用户已绑定券商账户
    var step: Int?
    /// 弹窗图片的oss地址
    var imageUrl: String?
    
    var buttonLinkAddress: String?
    var buttonText: String?
    var jumpLinkAddress: String?
    var jumpLinkDescribe: String?
    
}

extension Activity {
    enum FreeStep: Int {
        case right  = 1
        case risk
        case realName
        case account
        case build
        case done
    }
    
    var toastStep: FreeStep? {
        guard let step = step else {
            return nil
        }
        return FreeStep(rawValue: step)
    }
    var toastTitle: String? {
        guard let _ = self.buttonLinkAddress else { return nil }
        return buttonText
    }
    
    var toastMoreTitle: String? {
        guard let _ = self.jumpLinkAddress else { return nil }
        return "\(jumpLinkDescribe ?? "") >"
    }
    
    var toastMainPath: String? {
        self.buttonLinkAddress
    }
    var toastMorePath: String? {
        self.jumpLinkAddress
    }
}
