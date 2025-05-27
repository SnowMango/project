
import UIKit
import Then

class TagStackView: UIView {
    var interitemSpacing: CGFloat = 12
    var lineSpacing: CGFloat = 12
    var contentInset: UIEdgeInsets = .zero
    
    func cleanAllSubs() {
        let subs = self.subviews
        for sub in subs {
            sub.removeFromSuperview()
        }
        self.upadateContenSize(.zero)
    }
    func addArrangedSubview(_ view: UIView) {
        addSubview(view)
    }
    
    func upadateContenSize(_ itemSize: CGSize) {
        let contentFrame = self.bounds.inset(by: contentInset)
        var itemFrame = CGRect(origin: .zero, size: itemSize)
        if  let last = self.subviews.last {
            let mx = last.frame.maxX + interitemSpacing + itemFrame.width
            if mx <= contentFrame.maxX {
                itemFrame.origin.x = last.frame.maxX + interitemSpacing
                itemFrame.origin.y = last.frame.minY
            }else {
                itemFrame.origin.x = contentFrame.minX
                itemFrame.origin.y = last.frame.maxY + lineSpacing
            }
        }
        let mh = itemFrame.maxY + contentInset.bottom
        if abs(self.bounds.maxY - mh) > 0.01 {
            self.frame.size.height = mh
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let subs = self.subviews
        let contentFrame = self.bounds.inset(by: contentInset)
        for (index, sub) in subs.enumerated() {
            let size = sub.intrinsicContentSize
            var itemFrame = CGRect(origin: .zero, size: size)
            if index == 0 {
                itemFrame.origin = contentFrame.origin
            } else  {
                let pre = subs[index - 1]
                let mx = pre.frame.maxX + interitemSpacing + size.width
                if mx <= contentFrame.maxX {
                    itemFrame.origin.x = pre.frame.maxX + interitemSpacing
                    itemFrame.origin.y = pre.frame.minY
                }else {
                    itemFrame.origin.x = contentFrame.minX
                    itemFrame.origin.y = pre.frame.maxY + lineSpacing
                }
            }
            sub.frame = itemFrame
        }
        if let last = self.subviews.last {
            let mh = last.frame.maxY + contentInset.bottom
            if abs(self.bounds.maxY - mh) > 0.01 {
                self.frame.size.height = mh
            }
        }
    }
}

