
import Foundation
import Moya

typealias NetworkCompletion<Success> =  (_ result: NetworkResult<Success>) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    var provider: MoyaProvider<MultiTarget>
    private init() {
        #if DEBUG
        let logger = NetworkLoggerPlugin.verbose
        #else
        let logger = NetworkLoggerPlugin.default
        #endif
        provider = MoyaProvider<MultiTarget>(plugins: [logger])
    }
    @discardableResult
    func request<Value>(_ target: AppTargetProtocol, completion: @escaping NetworkCompletion<Value>) -> Cancellable where Value: Decodable {
        return provider.request(target.asMuti) { result in
            do {
                let response = try result.get()
                if !Array(200..<300).contains(response.statusCode) {
                    Logger.warn("success but statusCode is \(response.statusCode)")
                    completion(.failure(.network(MoyaError.statusCode(response))))
                    return
                }
                guard  let decoded = try? JSONDecoder().decode(BaseResponse<JSON?>.self, from: response.data) else {
                    completion(.failure(.decoding("response body not json")))
                    return
                }
                switch decoded.code {
                case 10051,10052:
                    AppManager.shared.showLogin(reason: decoded.msg)
                    completion(.failure(.token(decoded.msg ?? "")))
                case 200:
                    if let response = try? JSONDecoder().decode(BaseResponse<Value>.self, from: response.data){
                        completion(.success(response.data))
                    }else{
                        completion(.failure(.decoding("decoder model error")))
                    }
                    break
                default:
                    completion(.failure(.server(code: decoded.code, message: decoded.msg ?? "请求错误")))
                }
            } catch let error {
                completion(.failure(.network(error)))
            }
            
        }
    }
    

}


