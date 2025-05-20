
struct AppIconItem: Decodable {
    var iconUrl: String?
    var iconName: String?
    var iconLinkUrl: String?
    /// 位置 0首页金刚区 1我的页金刚区
    var position: Int = 0
}

