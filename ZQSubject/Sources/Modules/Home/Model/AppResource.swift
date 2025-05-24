
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
    var status: Int?
}
 
extension AppResource.ResourceData {
    func routing() {
        guard let path = self.linkAddress else { return }
        Router.shared.route(path)
    }
}
