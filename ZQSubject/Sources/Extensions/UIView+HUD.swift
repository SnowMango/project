import UIKit
import MBProgressHUD


public let delayTime = 2.0 //默认显示时间2.0s

extension UIView {
   
    /// 只显示文本
    ///
    /// - Parameters:
    ///   - title: 状态提示语
    ///   - afterDelay: 显示时间， 默认2.0s
    ///   - style: 样式，默认黑底白字
    ///   - fontSize: 字体大小，默认14
    ///   - maxLine: 最大换行数，默认5
    ///   - alignment: 对齐方式，默认左对齐
    ///   - isUserInteractionEnabled: 是否可交互，默认不可交互
    ///   - backgroundColor: 背景色
    ///   - completionBlock: 完成回调
    public func showText(_ title: String?,
                         afterDelay: TimeInterval = delayTime,
                         fontSize: CGFloat = 14,
                         maxLine: Int = 5,
                         alignment: NSTextAlignment = .left,
                         isUserInteractionEnabled: Bool = false,
                         contentColor: UIColor = .white,
                         backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                         completionBlock: (() -> Void)? = nil) {
        
        if self.isHudShow() == true {
            //return
            self.hideHud()
        }
        
        guard let title = title else { return }
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = .text
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = backgroundColor
        hud.isUserInteractionEnabled = !isUserInteractionEnabled
        hud.margin = 15.0
        hud.label.textAlignment = alignment
        hud.label.text = title
        hud.label.numberOfLines = maxLine
        hud.label.font = UIFont.systemFont(ofSize: fontSize)
        hud.contentColor = contentColor
        hud.removeFromSuperViewOnHide = true
        if afterDelay != 0.0 {
            hud.hide(animated: true, afterDelay: afterDelay)
        }
        hud.completionBlock = {
            if completionBlock != nil {
                completionBlock!()
            }
        }
    }
    
    /// 默认loading框
    ///
    /// - Parameter title: 状态提示语
    /// - Parameter fontSize: 字体大小
    /// - Parameter contentColor: 内容颜色
    /// - Parameter backgroundColor: 背景颜色
    /// - Parameter afterDelay: 隐藏时间,默认不自动隐藏
    public func showLoading(_ title: String = "",
                            fontSize: CGFloat = 14,
                            isUserInteractionEnabled: Bool = false,
                            contentColor: UIColor = UIColor.init(red: 49/255.0, green: 87/255.0, blue: 182/255.0, alpha: 1),
                            backgroundColor: UIColor = .white,
                            afterDelay: Double = 0.0) {
        
        if self.isHudShow() == true {
            //return
            self.hideHud()
        }
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        //hud.mode = .indeterminate
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = backgroundColor
        hud.isUserInteractionEnabled = !isUserInteractionEnabled
        hud.customView = CustomLoadingView()
        hud.contentColor = contentColor
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        hud.margin = 15.0
        hud.label.font = UIFont.systemFont(ofSize: fontSize)
        hud.label.text = title
        
        hud.removeFromSuperViewOnHide = true
        
        if afterDelay != 0.0 {
            hud.hide(animated: true, afterDelay: afterDelay)
        }
    }
    
    public func showWithCustomView(_ title: String,
                                   customView: UIView,
                                   fontSize: CGFloat = 14,
                                   isUserInteractionEnabled: Bool = false,
                                   contentColor: UIColor = .white,
                                   backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                                   completionBlock: (() -> Void)? = nil) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.margin = 15.0
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = backgroundColor
        hud.isUserInteractionEnabled = !isUserInteractionEnabled
        hud.customView = customView //自定义视图
        hud.label.font = UIFont.systemFont(ofSize: fontSize)
        hud.label.text = title
        hud.contentColor = contentColor
        hud.removeFromSuperViewOnHide = true
        
        hud.hide(animated: true, afterDelay: delayTime)
        hud.completionBlock = {
            if let block = completionBlock {
                block()
            }
        }
    }
    
    /// 隐藏hud，成功状态提示
    ///
    /// - Parameters:
    ///   - title: 状态提示语
    ///   - completionBlock: 完成回调
    public func hideWithSuccess(_ title: String,
                                completionBlock: (() -> Void)? = nil) {
        if let _ = self.hudForView() {
            
            // 显示之前先让前面的立即消失
            MBProgressHUD.hide(for: self, animated: false)
            
            self.showWithCustomView(title,
                                    customView: UIImageView(image: UIImage(named: "common_success_black")),
                                    fontSize: 14,
                                    isUserInteractionEnabled: false,
                                    contentColor: .white,
                                    backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                                    completionBlock: completionBlock)
        }
    }
    
    /// 隐藏hud，错误状态提示
    ///
    /// - Parameter title: 状态提示语
    ///   - completionBlock: 完成回调
    public func hideWithError(_ title: String,
                              completionBlock: (() -> Void)? = nil) {
        if let _ = self.hudForView() {
            
            // 显示之前先让前面的立即消失
            MBProgressHUD.hide(for: self, animated: false)
            
            self.showWithCustomView(title,
                                    customView: UIImageView(image: UIImage(named: "connom_error_black")),
                                    fontSize: 14,
                                    isUserInteractionEnabled: false,
                                    contentColor: .white,
                                    backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                                    completionBlock: completionBlock)
        }
    }
    
    /// 隐藏hud，显示提示文本
    ///
    /// - Parameter title: 提示文本
    ///   - completionBlock: 完成回调
    public func hideWithMessage(_ title: String,
                                completionBlock: (() -> Void)? = nil) {
        if let _ = self.hudForView() {
            
            // 显示之前先让前面的立即消失
            MBProgressHUD.hide(for: self, animated: false)
            
            self.showText(title, completionBlock: completionBlock)
        }
    }
    
    /// 隐藏hud
    ///
    /// - Parameter animated: 是否执行动画，默认为true
    public func hideHud(animated: Bool = true,
                        completionBlock: (() -> Void)? = nil) {
        let hud = self.hudForView()
        //hud?.hide(animated: animated, afterDelay: 0.25)
        hud?.hide(animated: animated, afterDelay: 0.01)
        hud?.completionBlock = {
            if let block = completionBlock {
                block()
            }
        }
    }
    
    //MARK: - Private Function
    
    /// 返回当前view最顶部的HUD
    ///
    /// - Returns: 返回当前view最顶部的HUD
    private func hudForView() -> MBProgressHUD? {
        let elements = self.subviews.reversed()
        for view in elements {
            if view is MBProgressHUD {
                return view as? MBProgressHUD
            }
        }
        
        return nil
    }
    
    /// 当前view是否已经显示了hud
    ///
    /// - Returns: true/false
    private func isHudShow() -> Bool {
        for subView in self.subviews {
            if subView is MBProgressHUD {
                return true
            }
        }
        
        return false
    }

}

class CustomLoadingView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        let cstView = UIImageView(image: UIImage(named: "hud_loading"))
        cstView.frame.size = CGSize(width: 25, height: 27)
        cstView.center = self.center
        self.addSubview(cstView)
        transformAnimation(view: cstView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    fileprivate func transformAnimation(view:UIView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi*2
        animation.duration = 2
        animation.autoreverses = false
        // 解决动画结束后回到原始状态的问题
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        // 一直旋转
        animation.repeatCount = MAXFLOAT
        view.layer.add(animation, forKey: nil)
    }
}


///渐变色
enum GradientPosition {
    ///左上->右上
    case topLeft2topRight
    ///左上->右下
    case topLeft2btmRight
    ///左上->左下
    case topLeft2btmLeft
}
//    gradientLayer.startPoint = CGPointMake(0, 0); // 左上
//    gradientLayer.endPoint = CGPointMake(0, 1); // 左下
//    gradientLayer.endPoint = CGPointMake(1, 0); // 右上
//    gradientLayer.endPoint = CGPointMake(1, 1); // 右下
extension UIView {
    
    ///设置渐变色
    func setgradientColor(startColor: UIColor, endColor: UIColor, postion: GradientPosition) {
        
        let colorOne:UIColor = startColor
        let colorTwo:UIColor = endColor
    
        let colors = [colorOne.cgColor,colorTwo.cgColor];
        let gradient:CAGradientLayer = CAGradientLayer.init();
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        switch postion {
            case .topLeft2btmLeft:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 0, y: 1)
            case .topLeft2btmRight:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 1, y: 1)
            case .topLeft2topRight:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 1, y: 0)
        }
        gradient.colors = colors;
        gradient.frame = self.bounds;
        //首先移除添加的渐变色layer
        if let _ = self.layer.sublayers {
            for layer in self.layer.sublayers! {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    /// 设置多段渐变色
    /// - Parameters:
    ///   - colors: 颜色集合
    ///   - locations: 变色的节点
    ///   - postion: 渐变色方向
    func setgradientColor(colors: [CGColor], locations: [NSNumber], postion: GradientPosition) {
        let gradient:CAGradientLayer = CAGradientLayer.init();
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        switch postion {
            case .topLeft2btmLeft:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 0, y: 1)
            case .topLeft2btmRight:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 1, y: 1)
            case .topLeft2topRight:
                gradient.startPoint = CGPoint.init(x: 0, y: 0)
                gradient.endPoint = CGPoint.init(x: 1, y: 0)
        }
        gradient.colors = colors;
        gradient.locations = locations
        gradient.frame = self.bounds;
        //首先移除添加的渐变色layer
        if let _ = self.layer.sublayers {
            for layer in self.layer.sublayers! {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    /// 设置圆角
    /// - Parameters:
    ///   - func_corner: 方位
    ///   - radii: 半径
    func setCorner(roundingCorners func_corner: UIRectCorner, cornerRadii radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: func_corner, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
