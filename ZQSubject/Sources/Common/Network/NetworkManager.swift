
import Foundation
import Moya

typealias NetworkCompletion<Success> =  (_ result: NetworkResult<Success>) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    private var provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private init() {
        
    }
    
    @discardableResult
    func request<Value>(_ target: AppTargetProtocol, completion: @escaping NetworkCompletion<Value>) -> Cancellable where Value: Decodable {
        return provider.request(target.asMuti) { result in
            switch result {
            case .success(let response):
                if let decoded = try? JSONDecoder().decode(BaseResponse<JSON?>.self, from: response.data) {
                    switch decoded.code {
                    case 10051:
                        AppManager.shared.showLogin(reason: decoded.msg)
                    case 10052:
                        AppManager.shared.showLogin(reason: decoded.msg)
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
                }else {
                    completion(.failure(.decoding("response body not json")))
                }
                break
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
}




