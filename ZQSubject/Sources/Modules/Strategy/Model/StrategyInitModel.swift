

class StrategyInitModel: Decodable {
    /// 文章分类
    var typeDtos: [StrategyArticleTypeModel]?
    /// 文章内容
    var articleDtos: [StrategyArticleModel]?
}

class StrategyArticleTypeModel: Decodable {
    var name: String?
    /// 分类id
    var id: String?
}

class StrategyArticleListModel: Decodable {
    var content: [StrategyArticleModel]?
}

struct StrategyArticleModel: Decodable {
   
    var id: Int
    
    var createTime: String?
    /// readingVolume
    var readingVolume: Int?
    /// 来源
    var source: String?
    /// 正文内容
    var textContent: String?
    /// 标题
    var title: String?
    /// 标题图片
    var titleUrl: String?
    /// 资讯类型 1市场分析 2量化资讯 3研报
    var type: Int
}


