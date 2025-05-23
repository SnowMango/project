import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
//        return self.connectedScenes
//            .compactMap { $0 as? UIWindowScene } // 获取所有 UIWindowScene
////            .filter { $0.activationState == .foregroundActive } // 只考虑当前活跃的 Scene
//            .flatMap { $0.windows } // 获取所有窗口
//            .first { $0.isKeyWindow } // 获取 keyWindow
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return nil }
        guard let window = windowScene.windows.first else { return nil }
        return window
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
    
    func open(_ viewController: UIViewController, animated: Bool) {
        guard let top = self.topController else { return }
        top.navigationController?.push(viewController, animated: animated)
    }
}

protocol TransformTopController {
    func topController() -> UIViewController
}

extension UIViewController: TransformTopController{
    @objc func topController() -> UIViewController {
        return self
    }
}
