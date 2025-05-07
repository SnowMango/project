
struct PagesResponse<T>  {
    var records:[T] = []
}

extension PagesResponse: Decodable where T: Decodable {
    
}
