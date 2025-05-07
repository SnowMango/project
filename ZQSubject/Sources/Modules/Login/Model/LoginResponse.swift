import Foundation

struct LoginResponse: Decodable {
    let mobile: String
    let token: String
}
