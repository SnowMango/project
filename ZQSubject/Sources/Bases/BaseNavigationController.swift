
import UIKit

class BaseNavigationController: UINavigationController {
   
    var helper: NavigationHelper = NavigationHelper()
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self.helper.delegate
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIViewController {
    @objc func stashInNavigationStack() -> Bool {
        return true
    }
}

extension UINavigationController {
    func push(_ viewController: UIViewController, animated: Bool) {
        let old = self.viewControllers
        var stack: [UIViewController] = []
        for controller in old {
            if controller.stashInNavigationStack() {
                stack.append(controller)
            }
        }
        if stack.count != old.count {
            stack.append(viewController)
            self.setViewControllers(stack, animated: animated)
            return
        }
        self.pushViewController(viewController, animated: animated)
    }
    
    func set(root: UIViewController, animated: Bool) {
        self.setViewControllers([root], animated: animated)
    }
}


class NavigationDelegate: NSObject { }

struct NavigationHelper {
    let delegate: NavigationDelegate
    init(delegate: NavigationDelegate = NavigationDelegate()) {
        self.delegate = delegate
    }
}

import ObjectiveC

extension UIViewController {
    @MainActor private struct BarKeys {
        static var navgation: Bool = false
//        static var logIndentation: Int = 0
    }

    var hiddenNavigationBarWhenShow: Bool {
        set {
            objc_setAssociatedObject(self, &BarKeys.navgation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &BarKeys.navgation) as? Bool ?? false
        }
    }
}

extension NavigationDelegate: UINavigationControllerDelegate {
    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let s = navigationController.navigationBar.isHidden
        let next = viewController.hiddenNavigationBarWhenShow
        if next != s {
            navigationController.setNavigationBarHidden(next, animated: animated)
        }
    }

    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

    }

    @available(iOS 7.0, *)
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        guard let top = navigationController.topViewController else {
            return .portrait
        }
        return top.supportedInterfaceOrientations
    }

    @available(iOS 7.0, *)
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        guard let top = navigationController.topViewController else {
            return .portrait
        }
        return top.preferredInterfaceOrientationForPresentation
    }

//    @available(iOS 7.0, *)
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
//
//    }

//    @available(iOS 7.0, *)
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
//
//    }
}

