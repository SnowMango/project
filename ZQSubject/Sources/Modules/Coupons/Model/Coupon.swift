
struct Coupon: Decodable {
    // MARK: - 枚举定义
    enum CouponType: Int, Codable {
        case priceReduction = 1
        case membership = 2
    }
    
    enum UseScope: Int, Codable {
        case all = 1
        case product = 2
        case category = 3
    }
    
    enum ObtainType: Int, Codable {
        case pointsExchange = 1
        case activityGift = 2
        case registrationGift = 3
    }
    
    enum Status: Int, Codable {
        case unused = 0
        case used = 1
        case expired = 2
        
        var desc: String {
            switch self {
            case .unused:
                "立即使用"
            case .used:
                "已使用"
            case .expired:
                "已过期"
            }
        }
    }
    
    // MARK: - 核心属性
    // 优惠券ID
    let couponId: Int
    // 优惠券名称
    let name: String
    // 优惠券类型 1-减价券（红包） 2-会员券
    let couponType: CouponType
    // 使用状态 0-未使用 1-已使用 2-已过期
    let status: Status
    // 有效期开始时间
    let validStartTime: String?
    // 有效期结束时间
    let validEndTime: String?
    
    // MARK: - 可选属性
    // 优惠券描述
    var description: String?
    // 优惠券图片地址
    var imageUrl: String?
    // 使用链接
    var jumpUrl: String?
    
    var price: Float?
    // 会员时长（天数，仅会员券类型有效）
    var memberDays: Int?
    // 门槛金额（最低消费金额）
    var thresholdAmount: Float?
    // 会员券备注信息
    var memberNote: String?
    
    // MARK: - 标志属性
    //是否可叠加使用 0-不可叠加 1-可叠加
    let canStack: Int
    // 是否有门槛 0-无门槛 1-有门槛
    let hasThreshold: Int
    // 优惠券使用范围 1-全平台 2-指定商品 3-指定品类
    let useScope: UseScope
    // 获取方式 1-积分兑换 2-活动赠送 3-注册赠送
    let obtainType: ObtainType
    
    // MARK: - 日期格式化
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    // MARK: - 计算属性
//    var isValid: Bool {
//        let now = Date()
//        return now >= validStartTime && now <= validEndTime
//    }
    
    
    var isPriceCoupon: Bool {
        couponType == .priceReduction
    }
    
    var discountValue: String {
        switch couponType {
        case .priceReduction:
            return price != nil ? "￥\(Int(price!))" : "无效面额"
        case .membership:
            return memberDays != nil ? "\(memberDays!)天" : "无效时长"
        }
    }
    
    var discountTime: String {
        var times: [String] = []
        if let time = validStartTime {
            times.append(time.components(separatedBy: " ").first!.replacingOccurrences(of: "-", with: "."))
        }
        if let time = validEndTime {
            times.append(time.components(separatedBy: " ").first!.replacingOccurrences(of: "-", with: "."))
        }
        return times.joined(separator: "-")
    }
}


