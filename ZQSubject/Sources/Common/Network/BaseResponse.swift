
import Foundation
import SwiftyJSON

struct BaseResponse<T> {
    ///返回结果类型
    let code: Int
    /// 请求返回msg
    let msg: String?
    let data: T
}

extension BaseResponse: Decodable where T: Decodable {}

typealias JSON = SwiftyJSON.JSON

enum NetworkError: Error{
    case server(code:Int, message:String)
    case network(Error)
    case decoding(String)
    case token(String)
    
    var localizedDescription: String {
        switch self {
        case .server(let code, let message):
            return "服务器错误 (\(code)): \(message)"
        case .network(let error):
            return "网络错误: \(error.localizedDescription)"
        case .decoding(let string):
            return "数据解析错误: \(string)"
        case .token(let string):
            return "登录错误: \(string)"
        }
    }
}

typealias NetworkResult<Success> = Result<Success , NetworkError>
typealias OptionalJSONResult = NetworkResult<JSON?>
typealias JSONResult = NetworkResult<JSON>

typealias NetworkPageResult<Success> = NetworkResult<PagesResponse<Success>>

