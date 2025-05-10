import UIKit

class Tools {
    /// json转字典
    class func convertJsonToDictionary(_ jsonString:String) -> NSDictionary {
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
    /// json转数组
    class func convertJsonToArray(jsonString:String) -> NSArray{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return []
    }
    
    
    /// 字典转json
    class func convertDictionaryToJson(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : Data! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as Data?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    
    /// 数组转json
    class func convertArrayToJson(array:NSArray) -> String {
        
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        
        let data : Data! = try? JSONSerialization.data(withJSONObject: array, options: []) as Data?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    /// 获取当前控制器
    class func getTopVC() -> UIViewController {
        if let top = UIApplication.shared.topController {
            return top
        }
        let window = UIApplication.shared.keyWindow
        var vc: UIViewController = window!.rootViewController!
        
        while true {
            if vc.isKind(of: UITabBarController.classForCoder()) {
                let temp = vc as! UITabBarController
                vc = temp.selectedViewController!
            }
            if vc.isKind(of: UINavigationController.classForCoder()) {
                let temp = vc as! UINavigationController
                vc = temp.visibleViewController!
            }
            if let temp = vc.presentedViewController {
                vc = temp
            } else {
                break
            }
        }
        return vc
    }
    
}

extension UIApplication {
    var topController: UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let root = window.rootViewController else { return nil}
        return findController(root)
    }
    private func findController(_ controller: UIViewController) -> UIViewController {
        if let navi = controller as? UINavigationController, let top = navi.topViewController {
            return self.findController(top)
        } else if let tab = controller as? UITabBarController, let top = tab.selectedViewController {
            return self.findController(top)
        }
        if let presented = controller.presentedViewController {
            return self.findController(presented)
        }
        return controller.topController()
    }
}

protocol TransformTopController {
    func topController() -> UIViewController
}

extension UIViewController: TransformTopController{
    func topController() -> UIViewController {
        return self
    }
}
