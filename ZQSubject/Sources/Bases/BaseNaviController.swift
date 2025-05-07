import UIKit

class BaseNaviController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        func_resetUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = self.topViewController?.view.backgroundColor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        func_resetUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var line: UIView = {
//        return UIView()
//    }()
    
    private func func_resetUI() {
//        line.removeFromSuperview()
//        self.navigationBar.shadowImage = UIImage()
//        line.backgroundColor = .kSeparateLine
//        self.navigationBar.addSubview(line)
//        
//        //更改约束在iphone6s iOS10.1出现了闪退,报错"Cannot modify constraints for UINavigationBar managed by a controller"
//        let frame = self.navigationBar.frame
//        line.frame = CGRect(x: 0, y: frame.maxY - 1, width: frame.width, height: 1)
    }
}
