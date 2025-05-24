
import UIKit
import Then
import RxCocoa
import RxSwift
import Kingfisher

class MineBannerView: UIView {
    
    var items: [AppResource.ResourceData] = [] {
        didSet {
            remakeUI()
        }
    }
    
    func cleanAllSubs() {
        let subs = self.subviews
        for sub in subs {
            sub.removeFromSuperview()
        }
    }
    
    func setupUI() {
        for (index, item) in items.enumerated() {
            if index > 3 { break }
            let iv = makeImg()
            iv.tag = index
            iv.addTapGesture(self, sel: #selector(tapImg))
            iv.backgroundColor = .random
            if let url = item.resourceUrl {
                iv.kf.setImage(with: url.validURL())
            }
            addSubview(iv)
        }
    }
    
    @objc func tapImg(_ tap: UITapGestureRecognizer) {
        guard let tapView = tap.view else { return }
        let item = self.items[tapView.tag]
        item.routing()
    }
    
    func remakeUI() {
        cleanAllSubs()
        setupUI()
        let itemHeigh = wScale(80)
        let spacing = wScale(14)
        let fullHeight = itemHeigh*2 + spacing
        let style = items.count
        if style == 1 {
            let view = self.subviews[0]
            view.snp.makeConstraints { make in
                make.left.right.top.equalTo(0)
                make.height.equalTo(fullHeight)
                make.bottom.lessThanOrEqualTo(0)
            }
        } else if style == 2 {
            let view1 = self.subviews[0]
            let view2 = self.subviews[1]
            view1.snp.makeConstraints { make in
                make.left.top.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.bottom.lessThanOrEqualTo(0)
            }
            view2.snp.makeConstraints { make in
                make.right.top.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.left.equalTo(view1.snp.right).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
        } else if style == 3 {
            let view1 = self.subviews[0]
            let view2 = self.subviews[1]
            let view3 = self.subviews[2]
            view1.snp.makeConstraints { make in
                make.left.top.equalTo(0)
                make.height.equalTo(fullHeight)
                make.bottom.lessThanOrEqualTo(0)
            }
            view2.snp.makeConstraints { make in
                make.right.top.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.left.equalTo(view1.snp.right).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
            view3.snp.makeConstraints { make in
                make.right.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.top.equalTo(view2.snp.bottom).offset(spacing)
                make.left.equalTo(view1.snp.right).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
        } else if style == 4 {
            let view1 = self.subviews[0]
            let view2 = self.subviews[1]
            let view3 = self.subviews[2]
            let view4 = self.subviews[3]
            view1.snp.makeConstraints { make in
                make.left.top.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.bottom.lessThanOrEqualTo(0)
            }
            view2.snp.makeConstraints { make in
                make.right.top.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.left.equalTo(view1.snp.right).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
            
            view3.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.top.equalTo(view1.snp.bottom).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
            view4.snp.makeConstraints { make in
                make.right.equalTo(0)
                make.height.equalTo(itemHeigh)
                make.top.equalTo(view2.snp.bottom).offset(spacing)
                make.left.equalTo(view3.snp.right).offset(spacing)
                make.width.equalTo(view1)
                make.bottom.lessThanOrEqualTo(0)
            }
        }
    }
    
    func makeImg() -> UIImageView {
        UIImageView().then {
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
        }
    }
    
    lazy var icon1IV: UIImageView = {
        return UIImageView()
    }()
    
    lazy var icon2IV: UIImageView = {
        return UIImageView()
    }()
    
    lazy var icon3IV: UIImageView = {
        return UIImageView()
    }()
    
    lazy var icon4IV: UIImageView = {
        return UIImageView()
    }()
}

