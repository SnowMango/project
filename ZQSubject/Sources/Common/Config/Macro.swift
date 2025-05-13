import UIKit

// MARK: - 屏幕宽高
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public func wScale(_ w: CGFloat) -> CGFloat {
    
    //抹去了小数位,因为在不同倍数的屏幕中,设置的小数位会根据1px来实际调整,所以小数位变得不可控.
    //如传进来"2.3",在2x倍数下实际会是2.5(0.5pt对应1px),在3x倍数下实际会是2.67(0.333pt对应1px).
    return (w * SCREEN_WIDTH / 375.0).rounded(.towardZero)
}

/// 顶部安全区高度
public func kSafeTopH() -> CGFloat {
    
    let scene = UIApplication.shared.connectedScenes.first
    guard let windowScene = scene as? UIWindowScene else { return 0 }
    guard let window = windowScene.windows.first else { return 0 }
    return window.safeAreaInsets.top
    
}

/// 底部安全区高度
public func kSafeBottomH() -> CGFloat {
    
    let scene = UIApplication.shared.connectedScenes.first
    guard let windowScene = scene as? UIWindowScene else { return 0 }
    guard let window = windowScene.windows.first else { return 0 }
    return window.safeAreaInsets.bottom
    
}

/// 顶部状态栏高度（包括安全区）
public func kStatusBarH() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    
    let scene = UIApplication.shared.connectedScenes.first
    guard let windowScene = scene as? UIWindowScene else { return 0 }
    guard let statusBarManager = windowScene.statusBarManager else { return 0 }
    statusBarHeight = statusBarManager.statusBarFrame.height
    
    return statusBarHeight
}

/// 导航栏高度
public func kNavigationBarH() -> CGFloat {
    return 44
}

/// 状态栏+导航栏的高度
public func kNavigationFullHeight() -> CGFloat {
    return kStatusBarH() + kNavigationBarH()
}

/// 底部导航栏高度
public func kTabBarH() -> CGFloat {
    return 49
}

/// 底部导航栏高度（包括安全区）
public func kTabBarFullHeight() -> CGFloat {
    return kTabBarH() + kSafeBottomH()
}

//是刘海屏系列
public func isIphoneXSerial() -> Bool {
    return kSafeTopH() > 20
}

let UMAppKey: String = "680e2ae5ae19113448a41da8"

///iPhone系统版本
public let kDeviceSystemVersion = UIDevice.current.systemVersion

///操作系统名称。ios
public let kDeviceSystemName = UIDevice.current.systemName

///设备udid
public let kDeviceUDID = UIDevice.current.identifierForVendor

/// APP版本号
public let kAppVersion: String  = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

///APP应用名
public let kAppName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

/// App路由
public let AppScheme: String = Bundle.main.object(forInfoDictionaryKey: "JLRoutesGlobalRoutesScheme") as! String

//public let AppBuildVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

public var AppBuildVersion: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
}
