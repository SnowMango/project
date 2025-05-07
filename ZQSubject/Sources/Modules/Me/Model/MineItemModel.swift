
import Foundation
import Then

protocol MineItemLoadProtocol {
    func load(_ item: MineItemModel)
}

class MineItemModel {
    enum Identifier: String{
        case account   /// 开户
        case group     /// 交流群
        case normal    /// 设置等等
        case banner    /// 广告
        
        var rowHeight: CGFloat {
            switch self {
            case .account:
                wScale(76)
            case .group:
                wScale(76)
            case .normal:
                wScale(50)
            case .banner:
                wScale(150)
            }
        }
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
    var title: String?
    var link: String?
    var iconName: String?
    
    var identifier: MineItemModel.Identifier = .normal
    
    init(title: String? = nil, link: String? = nil, iconName: String? = nil, identifier: MineItemModel.Identifier) {
        self.title = title
        self.link = link
        self.iconName = iconName
        self.identifier = identifier
    }

    static let Account: MineItemModel = .init(identifier: .account)
    static let Group: MineItemModel = .init(identifier: .group)
    
    /// 设置
    static let Setting: MineItemModel =  .init(title: "设置",
                                               link: "/app/setting",
                                               iconName: "mine.setting",
                                               identifier: .normal)
    /// 意见反馈
    static let Feedback: MineItemModel = .init(title: "意见反馈",
                                               link: "/feedback",
                                               iconName: "mine.feedback",
                                               identifier: .normal)
    /// 客服中心
    static let Support: MineItemModel = .init(title: "客服中心",
                                              link: AppLink.support.path,
                                              iconName: "mine.support",
                                              identifier: .normal)
    /// 实名认证
    static let RealAuth: MineItemModel = .init(title: "实名认证",
                                               link: "/commit/auth?needOpen=0",
                                               iconName: "mine.real.auth",
                                               identifier: .normal)
    
    /// 设风险评估
    static let Assessment: MineItemModel = .init(title: "风险评估",
                                                 link: AppLink.risk.path,
                                                 iconName: "mine.assessment",
                                                 identifier: .normal)
    
    /// 服务器管理
    static let Servers: MineItemModel = .init(title: "服务器管理",
                                              link: AppLink.server.path,///"/servers",
                                              iconName: "mine.server",
                                              identifier: .normal)
    /// 我的订单
    static let Orders: MineItemModel = .init(title: "我的订单",
                                             link: AppLink.order.path,//"/orders",
                                             iconName: "mine.order",
                                             identifier: .normal)
    
    static let Banner: MineItemModel = .init(identifier: .banner)
    
}

extension MineItemModel: Then {}
