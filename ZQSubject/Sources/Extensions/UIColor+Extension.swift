import UIKit

extension UIColor {
    
    /// 随机色
    class var randomColor: UIColor {
        return UIColor(r: arc4random() % 256,
                       g: arc4random() % 256,
                       b: arc4random() % 256)
    }
    
    convenience init?(_ hexString: String, alpha: CGFloat = 1.0) {
        var string = ""
        let lowercaseHexString = hexString.lowercased()
        if lowercaseHexString.hasPrefix("0x") {
            string = lowercaseHexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(alpha))
        
    }
     
    
    /// 用数值初始化颜色，可传入16进制数字或10进制数字
    
    /// 数值初始化颜色
    /// - Parameter valueRGB: 可传入16进制数字或10进制数字
    /// - Parameter alpha: alpha description
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
                  alpha: alpha
        )
    }
    
    
    /// RGBA色值初始化颜色
    /// - Parameter r: 红色0~255
    /// - Parameter g: 绿色0~255
    /// - Parameter b: 蓝色0~255
    /// - Parameter alpha: 透明度
    convenience init(r: UInt32, g: UInt32, b: UInt32, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: CGFloat(alpha)
        )
    }
    
    static func dynamic(_ lightStyleColor: UIColor, _ darkStyleColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
           return UIColor.init { (collection) -> UIColor in
                if (collection.userInterfaceStyle == .dark) {
                    return darkStyleColor
                }
                return lightStyleColor
            }
        } else {
            return lightStyleColor
        }
    }
}
