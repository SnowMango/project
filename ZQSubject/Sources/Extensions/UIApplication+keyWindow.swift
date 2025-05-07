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
