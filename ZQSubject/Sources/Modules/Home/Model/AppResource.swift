
struct AppResource: Decodable {
    struct ResourceData: Decodable {
        var linkAddress: String?
        var message: String?
        var resourceName: String?
        var resourceUrl: String?
        var status: Int?
    }
    
    var resourceKey: String?
    var resourceName: String?
    var type: Int?
    var data: [ResourceData]
}
