
import JLRoutes
import Foundation

enum RouteTag  {
    case home
    case login
    case firstGuide
    case terms
    case backHome
    var routePath: String {
        switch self {
        case .home:
            return "/home"
        case .login:
            return "/login"
        case .firstGuide:
            return "/firstGuide"
        case .terms:
            return "/terms"
        case .backHome:
            return "/back/home"
        }
    }
}

class Router {
    let route = JLRoutes.global()
    static let shared = Router()
    
    init() {
        #if DEBUG
        JLRoutes.setVerboseLoggingEnabled(true)
        #endif
    }
    
    @discardableResult
    static func route(url:URL, parameters:[String: Any]? = nil) -> Bool {
        JLRoutes.routeURL(url, withParameters: parameters)
    }
    
    @discardableResult
    func route(_ path: String, parameters:[String: Any]? = nil) -> Bool {
        return route.routeURL(URL(string: path), withParameters: parameters)
    }
    
    @discardableResult
    func route(_ tag: RouteTag, parameters:[String: Any]? = nil) -> Bool {
        route(tag.routePath, parameters: parameters)
    }
    
}

