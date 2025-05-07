import UIKit

class BaseNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self.helper
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
extension UINavigationController {
    var helper: NavigationHelper {
        return NavigationHelper(base: self)
    }
}

class NavigationHelper: NSObject {
    deinit {
        print("\(#function) helper")
    }
    let base: UINavigationController
    init(base: UINavigationController) {
        self.base = base
    }
}

extension NavigationHelper: UINavigationControllerDelegate {
    @available(iOS 2.0, *)
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
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

