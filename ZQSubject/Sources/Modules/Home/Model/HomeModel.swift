struct HomeModel {
    var image1: String?
    var image2: String?
    var image3: String?
    var image4: String?
    var notice: NoticeModel?
    
    // 自定义字段映射,如果要设置CodingKeys的话,要使用的全部的属性都要写上来,不能只写特定的几个.
    enum CodingKeys: String, CodingKey {
        case image1 = "homeImage1"
        case image2 = "homeImage2"
        case image3 = "homeImage3"
        case image4 = "homeImage4"
        case notice = "noticeDto"
    }
}

struct NoticeModel {
    var content: String?
    var url: String?
    var id: String?
    var summary: String?
    var title: String?
}
