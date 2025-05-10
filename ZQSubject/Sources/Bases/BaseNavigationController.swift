import UIKit

class BaseNavigationController: UINavigationController {
   
    var helper: NavigationHelper = NavigationHelper()
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self.helper.delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class NavigationDelegate: NSObject { }

struct NavigationHelper {
    let delegate: NavigationDelegate
    init(delegate: NavigationDelegate = NavigationDelegate()) {
        self.delegate = delegate
    }
}

extension UIViewController {
    func hiddenNavigationBarWhenShow() -> Bool {
        return false
    }
}

extension NavigationDelegate: UINavigationControllerDelegate {
    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let barHidden = navigationController.isNavigationBarHidden
        let next = viewController.hiddenNavigationBarWhenShow()
        if barHidden != next {
            navigationController.setNavigationBarHidden(next, animated: animated)
        }
    }

    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }

    @available(iOS 7.0, *)
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }

    @available(iOS 7.0, *)
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        return .portrait
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

