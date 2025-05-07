import UIKit
import CommonCrypto

extension String {
    
    /// 删除指定字符
    /// - Parameter character: 指定字符
    /// - Returns: string
    func removeCharacter(_ character: String) -> String {
        if self.contains(character) {
            let characterSet = CharacterSet(charactersIn: character)
            return self.trimmingCharacters(in: characterSet)
        }
        return self
    }
    
    
    /// 富文本设置 字体大小 行间距 字间距
    
    /// 富文本设置
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 颜色
    ///   - lineSpaceing: 行间距
    ///   - wordSpaceing: 字间距
    /// - Returns: NSMutableAttributedString
    func attributedString(font: UIFont?, textColor: UIColor?, lineSpaceing: CGFloat?, wordSpaceing: CGFloat?, textAlign: NSTextAlignment = .natural) -> NSAttributedString {
        
        let attStr = NSMutableAttributedString(string: self)
        
        if let f = font {
            attStr.addAttribute(.font, value: f, range: NSRange(location: 0, length: self.count))
        }
        
        if let c = textColor {
            attStr.addAttribute(.foregroundColor, value: c, range: NSRange(location: 0, length: self.count))
        }
        
        if let ws = wordSpaceing {
            attStr.addAttribute(.kern, value: ws, range: NSRange(location: 0, length: self.count))
        }
        
        let style = NSMutableParagraphStyle()
        if let ls = lineSpaceing {
            style.lineSpacing = ls
        }
        
        
        style.alignment = textAlign
        attStr.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: self.count))
        
        return attStr
    }
    
    // MARK: - 编码 解码
    /// 返回有效的URL，防止url中包含中文、重复编码问题
    public func validURL() -> URL? {
        if let validString: String = self.validURL() {
            return URL(string: validString)
        }
        return nil
    }
    
    /// 返回有效的String，防止url中包含中文、重复编码问题
    public func validURL() -> String? {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.range(of: "%[0-9A-Fa-f]{2}", options: .regularExpression, range: nil, locale: nil) != nil {
            return str
            //        } else if let encodedString = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            //前端通过view框架开发，默认在url后面带#号，所以#号不能转码，如：https://app-web.youcai168.net/youcai_h5/index.html#/wealth/fund-index?type=1&token=de6740f396354db6a0d80fae4bef3fcf
        } else if let encodedString = str.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`%^{}\"[]|\\<> ").inverted) {
            return encodedString
        } else {
            return nil
        }
    }
    
    
    //时间戳转成字符串
    public func toTimeStr(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        if self.count > 10 {
            ///13位时间戳
            guard let timeInterval = Double(self) else { return "--" }
            
            let date:Date = Date.init(timeIntervalSince1970: timeInterval / 1000)
            let formatter = DateFormatter.init()
            formatter.dateFormat = dateFormat
            return formatter.string(from: date as Date)
        } else {
            ///10位时间戳
            guard let timeInterval = Double(self) else { return "--" }
            
            let date:Date = Date.init(timeIntervalSince1970: timeInterval)
            let formatter = DateFormatter.init()
            formatter.dateFormat = dateFormat
            return formatter.string(from: date as Date)
        }
        
    }
    
    
    /// 是否符合正则匹配
    ///
    /// - Parameter pp_pattern: 正则
    /// - Returns: Bool
    public func matches(pp_pattern: String) -> Bool {
        return self.range(of: pp_pattern,
                          options: String.CompareOptions.regularExpression,
                          range: nil, locale: nil) != nil
    }
    
    /// 正则匹配到的第一个内容
    ///
    /// - Parameter pattern: 正则
    /// - Returns: 获取到的内容
    public func firstMatch(pattern: String) -> String? {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
           let result = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)),
           let range = Range(result.range, in: self) {
            return String(self[range])
        }
        return nil
    }
    
    /// 是否是手机号码
    ///
    /// - Returns: Bool
    public func isPhoneNumber() -> Bool {
        let pp_pattern = "1[3-9]\\d{9}" //因为现在号码号段逐渐增多,所以放宽判断.
        return matches(pp_pattern: pp_pattern)
    }
    
    /// 根据指定位置和长度获取字符串
    ///
    /// - Parameters:
    ///   - start: 开始
    ///   - length: 长度
    /// - Returns: 返回字符串
    public func subString(start: Int, length: Int? = nil) -> String? {
        if  start >= self.count || start < 0 {
            return nil
        }
        
        if length != nil && (length! < 0 || start + length! > self.count ) {
            return nil
        }
        
        let len = length ?? self.count - start
        let st = self.index(self.startIndex, offsetBy: start)
        let en = self.index(st, offsetBy: len)
        let range = st ..< en
        return String(self[range])
    }
    
    /// 手机号码脱敏
    ///
    /// - Returns: example 183****1261
    public func desensitizationPhone() -> String {
        guard self.isPhoneNumber() else {
            return self
        }
        return (self.subString(start: 0, length: 3)! + "****" + self.subString(start: self.count-4, length: 4)!)
    }
    
    /// 通过逗号分隔格式化的数据
    ///
    /// - Returns: 格式化金额类型数据,生成带逗号的数据,保留小数点后面的零
    public func stringSeparateByComma() -> String? {
        if Double(self) != nil {
            var newLong: Int64 = Int64(Double(self)! * 1000)
            
            if newLong % 10 > 4 {
                newLong += 10
            }
            
            newLong -= newLong % 10
            let rev2: Double = Double(newLong) * 1.0 / 1000.0
            let numberFormatter = NumberFormatter()
            numberFormatter.positiveFormat = "###,##0.00;"
            let formattedNumberString = numberFormatter.string(for: rev2)
            return formattedNumberString
        }
        return nil
    }
    
    public func isEmoji() -> Bool {
        let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        guard !numbers.contains(self) else {
            return false
        }
        
        if #available(iOS 10.2, *) {
            let scalars = self.unicodeScalars.map { $0.value }
            for element in scalars {
                if let scalar = Unicode.Scalar.init(element){
                    if scalar.properties.isEmoji {
                        return true
                    }
                }
            }
            return false
        }
        
        for scalars in unicodeScalars {
            switch scalars.value {
            case 0x1F600 ... 0x1F64F,
                0x1F300 ... 0x1F5FF,
                0x1F680 ... 0x1F6FF,
                0x2600 ... 0x26FF,
                0x2700 ... 0x27BF,
                0xFE00 ... 0xFE0F,
                0x1F900 ... 0x1F9FF:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    /// 通过字符串转换成颜色（16进制）
    public func toColor(_ failDefaultColor: UIColor = .white) -> UIColor {
        guard matches(pp_pattern: "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$") else {
            return failDefaultColor
        }
        let rStr = subString(start: 1, length: 2)!
        let gStr = subString(start: 3, length: 2)!
        let bStr = subString(start: 5, length: 2)!
        
        // 存储转换后的数值
        var red:UInt64 = 0, green:UInt64 = 0, blue:UInt64 = 0
        
        // 分别转换进行转换
        Scanner(string: rStr).scanHexInt64(&red)
        
        Scanner(string: gStr).scanHexInt64(&green)
        
        Scanner(string: bStr).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }
    
    public func labelSize(font: UIFont,fixedWidth width: CGFloat = 0, fixedHeight height: CGFloat = 0) -> CGSize {
        let text = self as NSString
        if width <= 0 && height <= 0 {
            return .zero
        }
        var size: CGSize = .zero
        if width > 0 {
            size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        } else {
            size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        }
        let rect = text.boundingRect(with: size, options: [.truncatesLastVisibleLine, .usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        // 不知道为什么，UIlabel差一点点显示不全
        return CGSize(width: rect.width + 1, height: rect.height + 1)
    }
    
    func urlToUIImage() -> UIImage? {
        guard let url = URL(string: self), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// base64 字符串转图片
    func base64StringToUIImage() -> UIImage? {
        if self.hasPrefix("data:") {
            guard let url = URL(string: self), let imgData = try? Data(contentsOf: url) else {
                return nil
            }
            return UIImage(data: imgData)
        }
        
        guard let decodedImgData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: decodedImgData)
    }
    
    /// 获取url的参数
    func urlParam(_ key: String) -> String? {
        
        let arr = split(separator: "?")
        guard arr.count > 0 else {
            return nil
        }
        
        let paramsStr = String(arr.last!)
        let paramArr = paramsStr.split(separator: "&")
        guard paramArr.count > 0 else {
            return nil
        }
        
        let replacedStr = "\(key)="
        for paramStr in paramArr {
            if paramStr.contains(replacedStr) {
                return paramStr.replacingOccurrences(of: replacedStr, with: "")
            }
        }
        return nil
    }
    
    ///文字转数字类型富文本,处理"％"
    func numberAttributeString(font: UIFont?) -> NSAttributedString? {
        let text = self
        let mutableAttributedString = NSMutableAttributedString(string: text)
        guard let font = font else {
            return mutableAttributedString
        }
        
        // 假设我们想要改变所有出现的 "%" 的颜色
        let pattern = try! NSRegularExpression(pattern: "%")
        let matches = pattern.matches(in: text, range: NSRange(text.startIndex..., in: text))
        
        matches.reversed().forEach { match in
            let range = Range(match.range(at: 0), in: text)!
            mutableAttributedString.addAttribute(.font, value: font, range: NSRange(range, in: text))
        }
        return mutableAttributedString
    }
}
