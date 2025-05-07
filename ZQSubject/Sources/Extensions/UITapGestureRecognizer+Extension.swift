import UIKit

extension UITapGestureRecognizer {
    /// 富文本点击位置计算
    
    /// 计算是不是点击在富文本指定的位置上
    /// - Parameters:
    ///   - label: 需要计算的文本框
    ///   - targetRange: 指定的点击范围
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let attributedText = NSMutableAttributedString(attributedString: label.attributedText!)
        //添加一个空格,处理点击文本最后一行的空白位置会一直返回"在点击范围内"的问题
        attributedText.append(NSAttributedString(string: " "))
        let textStorage = NSTextStorage(attributedString: attributedText)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        // 设置文本内容的默认间隔为0
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        // 获取文本内容的frame(注意:这个内容的frame,而是不是文本框的frame)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        // 计算文本内容的真实位置
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        // 把点击文本框的位置转换为相对于点击文本内容的位置
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        // 点击文本内容的位置是否在指定的文本内容中,如果在的话,返回的文本内容对应文本的坐标
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
