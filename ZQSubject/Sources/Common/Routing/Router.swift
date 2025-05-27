
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
        httpsRouter()
    }
    private func httpsRouter() {
        JLRoutes(forScheme: "https").addRoute("*") { req in
            guard let url = req[JLRouteURLKey] as? URL else { return false}
            UIApplication.shared.open(BaseWebController.load(url), animated: true)
            return false
        }
        
        JLRoutes(forScheme: "http").addRoute("*") { req in
            guard let url = req[JLRouteURLKey] as? URL else { return false}
            UIApplication.shared.open(BaseWebController.load(url), animated: true)
            return false
        }
        
        JLRoutes(forScheme: "liangjie").addRoute("*") { req in
            guard let url = req[JLRouteURLKey] as? URL else { return false}
            let appURL = url.absoluteString.replacingOccurrences(of: "liangjie://", with: "/web/")
            return self.route(appURL)
        }
    }
    @discardableResult
    static func route(url:URL, parameters:[String: Any]? = nil) -> Bool {
        JLRoutes.routeURL(url, withParameters: parameters)
    }
    
    @discardableResult
    func route(_ path: String, parameters:[String: Any]? = nil) -> Bool {
        return JLRoutes.routeURL(URL(string: path), withParameters: parameters)
    }
    
    @discardableResult
    func route(_ tag: RouteTag, parameters:[String: Any]? = nil) -> Bool {
        route(tag.routePath, parameters: parameters)
    }
    
}

